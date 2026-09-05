#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Creates / refreshes the PlatrareWidgets WidgetKit extension target and the
# App Group entitlement wiring in ios/Runner.xcodeproj.
#
# Idempotent: safe to re-run after adding Swift files. Re-run it whenever files
# are added under ios/PlatrareWidgets/ or ios/Shared/.
#
#   ruby tool/setup_ios_widget_target.rb
#
# Uses the `xcodeproj` gem that ships with CocoaPods.

require 'xcodeproj'

ROOT        = File.expand_path('..', __dir__)
PROJECT     = File.join(ROOT, 'ios', 'Runner.xcodeproj')
EXT_NAME    = 'PlatrareWidgets'
EXT_DIR     = File.join(ROOT, 'ios', EXT_NAME)
SHARED_DIR  = File.join(ROOT, 'ios', 'Shared')
APP_BUNDLE  = 'com.platrare.app'
EXT_BUNDLE  = "#{APP_BUNDLE}.#{EXT_NAME}"
# Must match DEVELOPMENT_TEAM in ios/Runner.xcodeproj/project.pbxproj; a
# stale value here silently re-signs the widget with the wrong team.
TEAM        = 'XAU336YV25'
APP_GROUP   = 'group.com.platrare.app'

project = Xcodeproj::Project.open(PROJECT)
runner  = project.targets.find { |t| t.name == 'Runner' } or abort 'Runner target not found'

# ── 1. Runner: App Group entitlements on ALL configurations ──────────────────
# There are three (Debug / Profile / Release). Missing Profile means
# `flutter run --profile` cannot resolve the group container and the snapshot
# silently goes nowhere.
runner.build_configurations.each do |config|
  config.build_settings['CODE_SIGN_ENTITLEMENTS'] = 'Runner/Runner.entitlements'
end
puts "Runner: CODE_SIGN_ENTITLEMENTS set on #{runner.build_configurations.map(&:name).join(', ')}"

# Register the entitlements file in the Runner group so it shows up in Xcode.
runner_group = project.main_group['Runner'] || project.main_group.new_group('Runner', 'Runner')
unless runner_group.files.any? { |f| f.path == 'Runner.entitlements' }
  runner_group.new_reference('Runner.entitlements')
end

# ── 2. Create (or find) the extension target ─────────────────────────────────
ext = project.targets.find { |t| t.name == EXT_NAME }
if ext.nil?
  ext = project.new_target(:app_extension, EXT_NAME, :ios, '17.0')
  puts "Created target #{EXT_NAME}"
else
  puts "Target #{EXT_NAME} already exists — refreshing"
end

# ── 3. Base configuration: inherit Flutter's version strings ─────────────────
ext_group = project.main_group[EXT_NAME] || project.main_group.new_group(EXT_NAME, EXT_NAME)
xcconfig_ref = ext_group.files.find { |f| f.path == 'Widgets.xcconfig' } ||
               ext_group.new_reference('Widgets.xcconfig')
ext.build_configurations.each { |c| c.base_configuration_reference = xcconfig_ref }

# ── 4. Build settings ────────────────────────────────────────────────────────
ext.build_configurations.each do |config|
  s = config.build_settings
  s['IPHONEOS_DEPLOYMENT_TARGET']      = '17.0'
  s['TARGETED_DEVICE_FAMILY']          = '1'
  s['PRODUCT_BUNDLE_IDENTIFIER']       = EXT_BUNDLE
  s['PRODUCT_NAME']                    = '$(TARGET_NAME)'
  s['DEVELOPMENT_TEAM']                = TEAM
  s['CODE_SIGN_STYLE']                 = 'Automatic'
  s['CODE_SIGN_ENTITLEMENTS']          = "#{EXT_NAME}/#{EXT_NAME}.entitlements"
  s['INFOPLIST_FILE']                  = "#{EXT_NAME}/Info.plist"
  s['SWIFT_VERSION']                   = '5.0'
  s['SKIP_INSTALL']                    = 'YES'
  s['SWIFT_EMIT_LOC_STRINGS']          = 'YES'
  s['GENERATE_INFOPLIST_FILE']         = 'NO'
  s['ENABLE_USER_SCRIPT_SANDBOXING']   = 'NO'
  s['CLANG_ENABLE_MODULES']            = 'YES'
  s['ALWAYS_SEARCH_USER_PATHS']        = 'NO'
  s['MTL_FAST_MATH']                   = 'YES'
  # Version strings MUST match the host app or App Store validation rejects
  # the appex. These come from Widgets.xcconfig -> Flutter/Generated.xcconfig.
  s['MARKETING_VERSION']               = '$(FLUTTER_BUILD_NAME)'
  s['CURRENT_PROJECT_VERSION']         = '$(FLUTTER_BUILD_NUMBER)'
  s['ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME'] = 'AccentColor'
  s['ASSETCATALOG_COMPILER_WIDGET_BACKGROUND_COLOR_NAME'] = 'WidgetBackground'
  # Deliberately NOT set: any Pods-*.xcconfig base config, and no SPM product
  # dependency. The appex links only WidgetKit / SwiftUI / AppIntents.
end

# ── 5. Source files ──────────────────────────────────────────────────────────
# Globbed so this script can be re-run as phases add files.
# Paths are relative to the group, which already carries its own directory
# path (e.g. group "PlatrareWidgets" -> path "PlatrareWidgets"). Prefixing the
# group name again yields PlatrareWidgets/PlatrareWidgets/Foo.swift.
def sync_group(project, group, dir)
  return [] unless Dir.exist?(dir)
  Dir.glob(File.join(dir, '**', '*.swift')).sort.map do |abs|
    rel = abs.sub("#{dir}/", '')
    group.files.find { |f| f.path == rel } || group.new_reference(rel)
  end
end

shared_group = project.main_group['Shared'] || project.main_group.new_group('Shared', 'Shared')
ext_refs     = sync_group(project, ext_group, EXT_DIR)
shared_refs  = sync_group(project, shared_group, SHARED_DIR)

# Prune references to files that no longer exist on disk, otherwise a deleted
# source keeps failing the build with "Build input file cannot be found".
PRUNABLE = %w[.swift .xcstrings .strings].freeze
[[ext_group, EXT_DIR], [shared_group, SHARED_DIR], [runner_group, File.join(ROOT, 'ios', 'Runner')]].each do |group, dir|
  group.files.dup.each do |ref|
    next unless PRUNABLE.any? { |ext| ref.path.to_s.end_with?(ext) }
    next if File.exist?(File.join(dir, ref.path))
    puts "  pruning missing #{ref.path}"
    ref.remove_from_project
  end
end

# Extension compiles its own sources + the shared intent/model types.
existing = ext.source_build_phase.files_references
(ext_refs + shared_refs).each do |ref|
  ext.source_build_phase.add_file_reference(ref) unless existing.include?(ref)
end

# The app target also compiles the shared types (it must be able to *execute*
# the intents the extension constructs), plus its own new Swift files.
runner_existing = runner.source_build_phase.files_references
runner_swift = Dir.glob(File.join(ROOT, 'ios', 'Runner', '*.swift')).sort.map do |abs|
  rel = File.basename(abs)
  runner_group.files.find { |f| f.path == rel } || runner_group.new_reference(rel)
end
(shared_refs + runner_swift).each do |ref|
  runner.source_build_phase.add_file_reference(ref) unless runner_existing.include?(ref)
end

# ── 6. Resources: Info.plist is NOT a resource; privacy manifest is ──────────
%w[PrivacyInfo.xcprivacy Assets.xcassets Localizable.xcstrings Fixtures].each do |name|
  path = File.join(EXT_DIR, name)
  next unless File.exist?(path)
  ref = ext_group.files.find { |f| f.path == name } || ext_group.new_reference(name)
  ext.resources_build_phase.add_file_reference(ref) unless
    ext.resources_build_phase.files_references.include?(ref)
end

# Siri phrases: legacy per-language AppShortcuts.strings rather than a string
# catalog, because AppShortcuts.xcstrings requires a deployment target of
# iOS 17 and the app target still deploys to 13. These must be a PBXVariantGroup
# so the copy-resources phase preserves the .lproj folders — plain file
# references get flattened into the bundle root and localization breaks.
runner_dir = File.join(ROOT, 'ios', 'Runner')
langs = Dir.glob(File.join(runner_dir, '*.lproj'))
           .select { |d| File.exist?(File.join(d, 'AppShortcuts.strings')) }
           .map { |d| File.basename(d, '.lproj') }
           .sort

unless langs.empty?
  variant = runner_group.children.find do |c|
    c.is_a?(Xcodeproj::Project::Object::PBXVariantGroup) &&
      c.name == 'AppShortcuts.strings'
  end
  if variant.nil?
    variant = runner_group.new_variant_group('AppShortcuts.strings')
  end
  langs.each do |lang|
    rel = "#{lang}.lproj/AppShortcuts.strings"
    next if variant.children.any? { |c| c.path == rel }
    ref = variant.new_reference(rel)
    ref.name = lang
  end
  unless runner.resources_build_phase.files_references.include?(variant)
    runner.resources_build_phase.add_file_reference(variant)
  end
  known = project.root_object.known_regions || []
  project.root_object.known_regions = (known + langs + %w[Base en]).uniq
  puts "  AppShortcuts.strings: #{langs.size} locales"
end
# Entitlements + Info.plist must be visible in the group but never in a phase.
%w[PlatrareWidgets.entitlements Info.plist].each do |name|
  next unless File.exist?(File.join(EXT_DIR, name))
  ext_group.files.find { |f| f.path == name } || ext_group.new_reference(name)
end

# ── 7. Embed the appex into Runner.app/PlugIns ───────────────────────────────
embed = runner.build_phases.find do |p|
  p.is_a?(Xcodeproj::Project::Object::PBXCopyFilesBuildPhase) &&
    p.name == 'Embed Foundation Extensions'
end
if embed.nil?
  embed = runner.new_copy_files_build_phase('Embed Foundation Extensions')
  embed.symbol_dst_subfolder_spec = :plug_ins
  # Must run before the Flutter "Thin Binary" phase so the appex gets thinned
  # and signed together with the app.
  runner.build_phases.delete(embed)
  thin_index = runner.build_phases.index { |p| p.respond_to?(:name) && p.name == 'Thin Binary' }
  runner.build_phases.insert(thin_index || runner.build_phases.length, embed)
end
unless embed.files_references.include?(ext.product_reference)
  bf = embed.add_file_reference(ext.product_reference)
  bf.settings = { 'ATTRIBUTES' => ['RemoveHeadersOnCopy'] }
end
runner.add_dependency(ext) unless runner.dependencies.any? { |d| d.target == ext }

# ── 8. Target attributes so automatic signing + App Groups register ──────────
attrs = project.root_object.attributes['TargetAttributes'] ||= {}
[[runner, '1430'], [ext, '1500']].each do |target, created|
  a = attrs[target.uuid] ||= {}
  a['CreatedOnToolsVersion'] ||= created
  a['ProvisioningStyle'] = 'Automatic'
  caps = a['SystemCapabilities'] ||= {}
  caps['com.apple.ApplicationGroups.iOS'] = { 'enabled' => 1 }
end

project.save
puts "Saved #{PROJECT}"
puts "  extension sources: #{ext_refs.size}, shared: #{shared_refs.size}"
puts "  app group: #{APP_GROUP}"
