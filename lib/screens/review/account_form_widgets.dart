import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/account_lifecycle.dart';
import '../../data/app_data.dart' as data;
import '../../data/currency_localized_names.dart';
import '../../data/data_repository.dart';
import '../../data/user_settings.dart' as settings;
import '../../l10n/app_localizations.dart';
import '../../models/account.dart';
import '../../utils/balance_correction.dart';
import '../../utils/fx.dart' as fx;
import '../../utils/persistence_guard.dart';
import '../../widgets/account_avatar.dart';

// ─── Account icon / color presets ─────────────────────────────────────────────
// Curated for personal finance, household, business, investing, and major spend.

const List<IconData> _kAccountPickIcons = <IconData>[
  // People & relationships
  Icons.person_rounded,
  Icons.people_alt_rounded,
  Icons.groups_rounded,
  Icons.diversity_3_rounded,
  Icons.child_care_rounded,
  Icons.elderly_rounded,
  Icons.badge_rounded,
  Icons.support_agent_rounded,
  // Cash, cards & everyday banking
  Icons.account_balance_wallet_rounded,
  Icons.account_balance_rounded,
  Icons.savings_outlined,
  Icons.savings_rounded,
  Icons.credit_card_rounded,
  Icons.credit_score_rounded,
  Icons.payments_rounded,
  Icons.point_of_sale_rounded,
  Icons.local_atm_rounded,
  Icons.smartphone_rounded,
  Icons.attach_money_rounded,
  Icons.paid_rounded,
  Icons.currency_exchange_rounded,
  Icons.currency_bitcoin_rounded,
  // Trust & access
  Icons.shield_rounded,
  Icons.gpp_good_rounded,
  Icons.lock_rounded,
  Icons.vpn_key_rounded,
  // Work & business
  Icons.business_rounded,
  Icons.business_center_rounded,
  Icons.work_outline_rounded,
  Icons.cases_rounded,
  Icons.handshake_rounded,
  Icons.laptop_rounded,
  Icons.storefront_outlined,
  // Markets & analytics
  Icons.show_chart_rounded,
  Icons.candlestick_chart_rounded,
  Icons.bar_chart_rounded,
  Icons.pie_chart_rounded,
  Icons.stacked_bar_chart_rounded,
  Icons.trending_up_rounded,
  Icons.trending_down_rounded,
  // Invoices, tax & paperwork
  Icons.receipt_long_rounded,
  Icons.description_rounded,
  Icons.request_quote_rounded,
  Icons.calculate_rounded,
  Icons.percent_rounded,
  // Property & mobility
  Icons.apartment_rounded,
  Icons.holiday_village_rounded,
  Icons.home_outlined,
  Icons.real_estate_agent_rounded,
  Icons.flight_takeoff_rounded,
  Icons.train_rounded,
  Icons.directions_car_filled_rounded,
  Icons.electric_car_rounded,
  Icons.directions_boat_rounded,
  Icons.two_wheeler_rounded,
  // Living, health & discretionary
  Icons.shopping_bag_outlined,
  Icons.restaurant_rounded,
  Icons.local_hospital_rounded,
  Icons.school_outlined,
  Icons.fitness_center_rounded,
  Icons.movie_rounded,
  Icons.pets_rounded,
  Icons.volunteer_activism_rounded,
  // Utilities & transfers
  Icons.electric_bolt_rounded,
  Icons.water_drop_rounded,
  Icons.wifi_rounded,
  Icons.local_gas_station_rounded,
  Icons.swap_horiz_rounded,
  // More money, cards & tools (still finance-adjacent)
  Icons.monetization_on_rounded,
  Icons.account_tree_rounded,
  Icons.price_change_rounded,
  Icons.price_check_rounded,
  Icons.wallet_rounded,
  Icons.money_off_rounded,
  Icons.call_split_rounded,
  Icons.account_circle_rounded,
  Icons.add_card_rounded,
  Icons.atm_rounded,
  Icons.token_rounded,
  Icons.diamond_rounded,
  Icons.interests_rounded,
  Icons.rocket_launch_rounded,
  // Food & drink
  Icons.restaurant_menu_rounded,
  Icons.local_cafe_rounded,
  Icons.local_drink_rounded,
  Icons.cake_rounded,
  Icons.icecream_rounded,
  Icons.local_pizza_rounded,
  Icons.fastfood_rounded,
  Icons.breakfast_dining_rounded,
  Icons.lunch_dining_rounded,
  Icons.dinner_dining_rounded,
  Icons.ramen_dining_rounded,
  Icons.local_bar_rounded,
  Icons.wine_bar_rounded,
  Icons.liquor_rounded,
  Icons.emoji_food_beverage_rounded,
  Icons.set_meal_rounded,
  Icons.takeout_dining_rounded,
  Icons.rice_bowl_rounded,
  Icons.soup_kitchen_rounded,
  Icons.bakery_dining_rounded,
  // Travel, maps & places
  Icons.flight_rounded,
  Icons.flight_land_rounded,
  Icons.explore_rounded,
  Icons.map_rounded,
  Icons.public_rounded,
  Icons.language_rounded,
  Icons.flag_rounded,
  Icons.beach_access_rounded,
  Icons.spa_rounded,
  Icons.pool_rounded,
  Icons.weekend_rounded,
  Icons.bed_rounded,
  Icons.hotel_rounded,
  Icons.room_service_rounded,
  Icons.luggage_rounded,
  Icons.no_transfer_rounded,
  Icons.tram_rounded,
  Icons.subway_rounded,
  Icons.bus_alert_rounded,
  Icons.airport_shuttle_rounded,
  Icons.pedal_bike_rounded,
  Icons.electric_scooter_rounded,
  Icons.moped_rounded,
  Icons.rv_hookup_rounded,
  Icons.sailing_rounded,
  Icons.festival_rounded,
  Icons.museum_rounded,
  Icons.attractions_rounded,
  // Leisure & media
  Icons.music_note_rounded,
  Icons.piano_rounded,
  Icons.mic_rounded,
  Icons.headphones_rounded,
  Icons.radio_rounded,
  Icons.podcasts_rounded,
  Icons.newspaper_rounded,
  Icons.menu_book_rounded,
  Icons.auto_stories_rounded,
  Icons.camera_alt_rounded,
  Icons.photo_camera_rounded,
  Icons.photo_library_rounded,
  Icons.image_rounded,
  Icons.videocam_rounded,
  Icons.movie_filter_rounded,
  Icons.theater_comedy_rounded,
  Icons.casino_rounded,
  Icons.games_rounded,
  Icons.sports_esports_rounded,
  // Sports & outdoor activities
  Icons.sports_soccer_rounded,
  Icons.sports_basketball_rounded,
  Icons.sports_football_rounded,
  Icons.sports_tennis_rounded,
  Icons.sports_golf_rounded,
  Icons.sports_hockey_rounded,
  Icons.sports_baseball_rounded,
  Icons.sports_volleyball_rounded,
  Icons.sports_martial_arts_rounded,
  Icons.sports_mma_rounded,
  Icons.surfing_rounded,
  Icons.skateboarding_rounded,
  Icons.snowboarding_rounded,
  Icons.kayaking_rounded,
  Icons.hiking_rounded,
  Icons.paragliding_rounded,
  Icons.kitesurfing_rounded,
  Icons.scuba_diving_rounded,
  Icons.downhill_skiing_rounded,
  Icons.nordic_walking_rounded,
  Icons.sledding_rounded,
  Icons.ice_skating_rounded,
  Icons.roller_skating_rounded,
  Icons.emoji_events_rounded,
  Icons.military_tech_rounded,
  Icons.workspace_premium_rounded,
  Icons.emoji_emotions_rounded,
  Icons.emoji_objects_rounded,
  Icons.emoji_nature_rounded,
  Icons.emoji_transportation_rounded,
  // Nature, weather & environment
  Icons.nature_people_rounded,
  Icons.forest_rounded,
  Icons.park_rounded,
  Icons.yard_rounded,
  Icons.grass_rounded,
  Icons.local_florist_rounded,
  Icons.eco_rounded,
  Icons.recycling_rounded,
  Icons.energy_savings_leaf_rounded,
  Icons.compost_rounded,
  Icons.thermostat_rounded,
  Icons.wb_sunny_rounded,
  Icons.nights_stay_rounded,
  Icons.umbrella_rounded,
  Icons.ac_unit_rounded,
  Icons.fireplace_rounded,
  Icons.tsunami_rounded,
  Icons.volcano_rounded,
  Icons.thunderstorm_rounded,
  Icons.air_rounded,
  Icons.water_rounded,
  // Tech & devices
  Icons.light_rounded,
  Icons.flashlight_on_rounded,
  Icons.bolt_rounded,
  Icons.battery_charging_full_rounded,
  Icons.power_rounded,
  Icons.outlet_rounded,
  Icons.router_rounded,
  Icons.devices_rounded,
  Icons.tv_rounded,
  Icons.computer_rounded,
  Icons.tablet_mac_rounded,
  Icons.watch_rounded,
  Icons.headset_mic_rounded,
  Icons.keyboard_rounded,
  Icons.mouse_rounded,
  Icons.print_rounded,
  Icons.scanner_rounded,
  Icons.fax_rounded,
  Icons.phone_rounded,
  Icons.tablet_android_rounded,
  Icons.contact_phone_rounded,
  Icons.contact_mail_rounded,
  Icons.alternate_email_rounded,
  Icons.forward_to_inbox_rounded,
  Icons.mark_email_read_rounded,
  Icons.chat_rounded,
  Icons.forum_rounded,
  Icons.rss_feed_rounded,
  Icons.cast_rounded,
  Icons.speaker_rounded,
  Icons.memory_rounded,
  Icons.storage_rounded,
  Icons.sim_card_rounded,
  Icons.nfc_rounded,
  Icons.bluetooth_rounded,
  Icons.wifi_tethering_rounded,
  Icons.phonelink_ring_rounded,
  // Time, calendar & tasks
  Icons.calendar_month_rounded,
  Icons.event_rounded,
  Icons.event_available_rounded,
  Icons.event_note_rounded,
  Icons.schedule_rounded,
  Icons.alarm_rounded,
  Icons.alarm_on_rounded,
  Icons.hourglass_bottom_rounded,
  Icons.timer_rounded,
  Icons.more_time_rounded,
  Icons.update_rounded,
  Icons.history_rounded,
  Icons.today_rounded,
  Icons.date_range_rounded,
  Icons.checklist_rounded,
  Icons.task_alt_rounded,
  Icons.rule_rounded,
  Icons.gavel_rounded,
  Icons.balance_rounded,
  // Home, furniture & family
  Icons.chair_rounded,
  Icons.bedroom_child_rounded,
  Icons.bathroom_rounded,
  Icons.kitchen_rounded,
  Icons.dining_rounded,
  Icons.living_rounded,
  Icons.single_bed_rounded,
  Icons.stroller_rounded,
  Icons.toys_rounded,
  Icons.cottage_rounded,
  Icons.chalet_rounded,
  Icons.bungalow_rounded,
  Icons.villa_rounded,
  Icons.castle_rounded,
  Icons.church_rounded,
  Icons.temple_hindu_rounded,
  Icons.temple_buddhist_rounded,
  Icons.mosque_rounded,
  Icons.synagogue_rounded,
  Icons.fort_rounded,
  Icons.cabin_rounded,
  Icons.fence_rounded,
  Icons.door_front_door_rounded,
  Icons.window_rounded,
  Icons.garage_rounded,
  Icons.roofing_rounded,
  Icons.foundation_rounded,
  Icons.construction_rounded,
  Icons.plumbing_rounded,
  Icons.format_paint_rounded,
  Icons.hardware_rounded,
  Icons.agriculture_rounded,
  Icons.anchor_rounded,
  // Learning, science & ideas
  Icons.school_rounded,
  Icons.science_rounded,
  Icons.biotech_rounded,
  Icons.psychology_rounded,
  Icons.self_improvement_rounded,
  Icons.auto_fix_high_rounded,
  Icons.auto_awesome_rounded,
  Icons.lightbulb_rounded,
  Icons.tips_and_updates_rounded,
  Icons.quiz_rounded,
  Icons.extension_rounded,
  Icons.functions_rounded,
  Icons.data_object_rounded,
  Icons.hub_rounded,
  Icons.polyline_rounded,
  Icons.shape_line_rounded,
  Icons.auto_graph_rounded,
  Icons.multiline_chart_rounded,
  Icons.ssid_chart_rounded,
  // Rewards, gifts & social
  Icons.star_rounded,
  Icons.star_half_rounded,
  Icons.grade_rounded,
  Icons.favorite_rounded,
  Icons.favorite_border_rounded,
  Icons.celebration_rounded,
  Icons.card_giftcard_rounded,
  Icons.redeem_rounded,
  Icons.recommend_rounded,
  Icons.thumb_up_rounded,
  Icons.diversity_1_rounded,
  Icons.diversity_2_rounded,
  Icons.transgender_rounded,
  Icons.waving_hand_rounded,
  Icons.front_hand_rounded,
  Icons.back_hand_rounded,
  // Creative & editing
  Icons.create_rounded,
  Icons.draw_rounded,
  Icons.brush_rounded,
  Icons.palette_rounded,
  Icons.color_lens_rounded,
  Icons.design_services_rounded,
  Icons.architecture_rounded,
  Icons.animation_rounded,
  Icons.gif_box_rounded,
  Icons.sticky_note_2_rounded,
  Icons.article_rounded,
  Icons.feed_rounded,
  Icons.style_rounded,
  // Security, privacy & health (extra)
  Icons.admin_panel_settings_rounded,
  Icons.verified_user_rounded,
  Icons.privacy_tip_rounded,
  Icons.health_and_safety_rounded,
  Icons.medical_services_rounded,
  Icons.medication_rounded,
  Icons.vaccines_rounded,
  Icons.coronavirus_rounded,
  Icons.bloodtype_rounded,
  Icons.monitor_heart_rounded,
  Icons.hearing_rounded,
  Icons.visibility_rounded,
  Icons.visibility_off_rounded,
  Icons.fingerprint_rounded,
  // Animals & plants
  Icons.cruelty_free_rounded,
  Icons.filter_vintage_rounded,
  Icons.pest_control_rounded,
  Icons.bug_report_rounded,
  // Misc & playful (least “finance” — end of picker)
  Icons.rocket_rounded,
  Icons.hive_rounded,
  Icons.auto_awesome_motion_rounded,
  Icons.bubble_chart_rounded,
  Icons.scatter_plot_rounded,
  Icons.hexagon_rounded,
  Icons.pentagon_rounded,
  Icons.change_history_rounded,
  Icons.all_inclusive_rounded,
  Icons.flutter_dash_rounded,
  Icons.sentiment_satisfied_rounded,
  Icons.sentiment_very_satisfied_rounded,
  Icons.mood_rounded,
  Icons.face_rounded,
  Icons.cyclone_rounded,
  Icons.whatshot_rounded,
  Icons.local_fire_department_rounded,
  Icons.dangerous_rounded,
  Icons.warning_rounded,
  Icons.new_releases_rounded,
  Icons.loyalty_rounded,
  Icons.card_membership_rounded,
  Icons.confirmation_number_rounded,
  Icons.local_activity_rounded,
  Icons.local_play_rounded,
  Icons.nightlife_rounded,
  Icons.party_mode_rounded,
  Icons.android_rounded,
  Icons.apple_rounded,
  Icons.cookie_rounded,
  Icons.egg_rounded,
  Icons.coffee_maker_rounded,
  Icons.wb_cloudy_rounded,
  Icons.cloud_rounded,
  Icons.cloud_queue_rounded,
  Icons.storm_rounded,
  Icons.blur_on_rounded,
  Icons.blur_circular_rounded,
  Icons.traffic_rounded,
  Icons.emoji_flags_rounded,
  Icons.waves_rounded,
];

const List<int> _kAccountPickColorArgb = <int>[
  0xFF1565C0,
  0xFF2E7D32,
  0xFF6A1B9A,
  0xFFC62828,
  0xFFEF6C00,
  0xFF00838F,
  0xFF5D4037,
  0xFF455A64,
  0xFFAD1457,
  0xFF283593,
  0xFFF9A825,
  0xFF00695C,
];

Future<int?> _pickAccountIconCodePoint(
  BuildContext context, {
  required int current,
}) async {
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) {
      final cs = Theme.of(ctx).colorScheme;
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewPadding.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
              child: Text(
                l10n.accountIconSheetTitle,
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.text_fields_rounded, color: cs.primary),
              title: Text(l10n.accountUseInitialLetter),
              onTap: () => Navigator.pop(ctx, 0),
            ),
            const Divider(height: 1),
            SizedBox(
              height: (MediaQuery.of(ctx).size.height * 0.5).clamp(300, 480),
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: _kAccountPickIcons.length,
                itemBuilder: (_, i) {
                  final icon = _kAccountPickIcons[i];
                  final cp = icon.codePoint;
                  final sel = current != 0 && current == cp;
                  return Material(
                    color: sel
                        ? cs.primaryContainer
                        : cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.pop(ctx, cp),
                      child: Icon(icon, color: cs.onSurface),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<int?> _pickAccountColorArgb(
  BuildContext context, {
  required int? current,
}) async {
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) {
      final cs = Theme.of(ctx).colorScheme;
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewPadding.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
              child: Text(
                l10n.accountColorSheetTitle,
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.palette_outlined, color: cs.primary),
              title: Text(l10n.accountUseDefaultColor),
              onTap: () => Navigator.pop(ctx, -1),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final argb in _kAccountPickColorArgb)
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx, argb),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(argb),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: current == argb
                                ? cs.primary
                                : cs.outlineVariant,
                            width: current == argb ? 2.5 : 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _accountAppearanceEditorBlock(
  BuildContext context, {
  required Account previewAccount,
  required VoidCallback onPickIcon,
  required VoidCallback onPickColor,
}) {
  final l10n = AppLocalizations.of(context);
  final tt = Theme.of(context).textTheme;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        l10n.accountAppearanceSection,
        style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 10),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AccountAvatar(account: previewAccount, size: 52, borderRadius: 14),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton(
                  onPressed: onPickIcon,
                  child: Text(l10n.accountPickIcon),
                ),
                const SizedBox(height: 6),
                OutlinedButton(
                  onPressed: onPickColor,
                  child: Text(l10n.accountPickColor),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

// ─── Account Form Sheet ───────────────────────────────────────────────────────

Future<void> _showBalanceCorrectionDialog(
  BuildContext context, {
  required double previousBook,
  required double newBook,
  required Account account,
  required BalanceCorrectionResult correction,
}) async {
  final sym = fx.currencySymbol(account.currencyCode);
  final l10n = AppLocalizations.of(context);
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(l10n.balanceAdjustedTitle),
      content: Text(
        l10n.balanceAdjustedBody(
          previousBook.toStringAsFixed(2),
          newBook.toStringAsFixed(2),
          sym,
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.ok),
        ),
      ],
    ),
  );
}

/// Overdraft / advance limit applies only to personal accounts.
bool _accountGroupAllowsOverdraft(AccountGroup g) =>
    g == AccountGroup.personal;

class AccountFormSheet extends StatefulWidget {
  final Account? account;
  const AccountFormSheet({super.key, this.account});

  @override
  State<AccountFormSheet> createState() => _AccountFormSheetState();
}

class _AccountFormSheetState extends State<AccountFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _institutionController;
  late final TextEditingController _balanceController;
  late final TextEditingController _overdraftController;
  late AccountGroup _group;
  late String _currencyCode;
  late int _iconCodePoint;
  int? _colorArgb;
  bool _forceClose = false;

  double _parseOverdraftLimit() {
    final t = _overdraftController.text.trim();
    if (t.isEmpty) return 0;
    return (double.tryParse(t.replaceAll(',', '.')) ?? 0).clamp(0.0, 1e15);
  }

  /// Value that would be persisted (zero when group ≠ personal).
  double _effectiveOverdraftLimitForForm() =>
      _accountGroupAllowsOverdraft(_group) ? _parseOverdraftLimit() : 0.0;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.account?.name ?? '');
    _institutionController = TextEditingController(
      text: widget.account?.institution ?? '',
    );
    _balanceController = TextEditingController(
      text: widget.account != null
          ? widget.account!.balance.toStringAsFixed(2)
          : '',
    );
    _group = widget.account?.group ?? AccountGroup.personal;
    _overdraftController = TextEditingController(
      text: widget.account != null &&
              widget.account!.overdraftLimit > 0 &&
              _accountGroupAllowsOverdraft(_group)
          ? widget.account!.overdraftLimit.toStringAsFixed(2)
          : '',
    );
    _currencyCode = widget.account?.currencyCode ?? settings.baseCurrency;
    _iconCodePoint = widget.account?.iconCodePoint ?? 0;
    _colorArgb = widget.account?.colorArgb;
  }

  String _trimmedInstitution() {
    final t = _institutionController.text.trim();
    return t.isEmpty ? '' : t;
  }

  Account _previewAccountForSheet() {
    final name = _nameController.text.trim();
    final inst = _trimmedInstitution();
    return Account(
      id: widget.account?.id ?? 'preview',
      name: name.isEmpty ? '?' : name,
      institution: inst.isEmpty ? null : inst,
      group: _group,
      iconCodePoint: _iconCodePoint,
      colorArgb: _colorArgb,
      currencyCode: _currencyCode,
    );
  }

  Future<void> _pickIconForSheet() async {
    final v =
        await _pickAccountIconCodePoint(context, current: _iconCodePoint);
    if (!mounted || v == null) return;
    setState(() => _iconCodePoint = v);
  }

  Future<void> _pickColorForSheet() async {
    final v = await _pickAccountColorArgb(context, current: _colorArgb);
    if (!mounted || v == null) return;
    setState(() => _colorArgb = v < 0 ? null : v);
  }

  bool get _isDirty {
    final inst = _trimmedInstitution();
    final instExisting = widget.account?.institution?.trim() ?? '';
    final instNorm = inst.isEmpty ? '' : inst;
    if (widget.account != null) {
      return _nameController.text.trim() != widget.account!.name ||
          instNorm != instExisting ||
          _balanceController.text.trim() !=
              widget.account!.balance.toStringAsFixed(2) ||
          _group != widget.account!.group ||
          _effectiveOverdraftLimitForForm() !=
              widget.account!.overdraftLimit ||
          _currencyCode != widget.account!.currencyCode ||
          _iconCodePoint != widget.account!.iconCodePoint ||
          _colorArgb != widget.account!.colorArgb;
    }
    return _nameController.text.trim().isNotEmpty ||
        _balanceController.text.trim().isNotEmpty ||
        (_accountGroupAllowsOverdraft(_group) &&
            _parseOverdraftLimit() > 0) ||
        _currencyCode != settings.baseCurrency ||
        _group != AccountGroup.personal ||
        instNorm.isNotEmpty ||
        _iconCodePoint != 0 ||
        _colorArgb != null;
  }

  void _showDiscardDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.discardTitle),
        content: Text(l10n.discardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.keepEditing),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            child: Text(l10n.discard),
          ),
        ],
      ),
    ).then((discard) {
      if (discard == true && mounted) {
        setState(() => _forceClose = true);
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _institutionController.dispose();
    _balanceController.dispose();
    _overdraftController.dispose();
    super.dispose();
  }

  Future<void> _pickCurrency() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _CurrencyPickerSheet(selected: _currencyCode),
    );
    if (result != null) setState(() => _currencyCode = result);
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final instRaw = _trimmedInstitution();
    final institution = instRaw.isEmpty ? null : instRaw;
    if (isAccountDuplicate(
      name,
      institution,
      data.accounts,
      exceptAccountId: widget.account?.id,
    )) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).accountNameTaken,
          ),
        ),
      );
      return;
    }
    final balance = double.tryParse(
            _balanceController.text.trim().replaceAll(',', '.')) ??
        0.0;
    final overdraft = _effectiveOverdraftLimitForForm();
    if (widget.account != null) {
      final acc = widget.account!;
      final previousBook = acc.balance;
      final previousGroup = acc.group;
      acc.name = name;
      acc.institution = institution;
      acc.group = _group;
      if (previousGroup != _group) {
        acc.sortOrder = DataRepository.nextSortOrderInGroup(
          acc.group,
          excludeAccountId: acc.id,
        );
      }
      acc.overdraftLimit = overdraft;
      acc.iconCodePoint = _iconCodePoint;
      acc.colorArgb = _colorArgb;

      late BalanceCorrectionResult correction;
      final ok = await guardPersist(context, () async {
        correction = await applyLedgerBalanceCorrection(
          account: acc,
          previousBookBalance: previousBook,
          newBookBalance: balance,
        );
        if (!correction.inserted) {
          acc.balance = balance;
        }
        await DataRepository.persistAccountFields(acc);
      });
      if (!mounted) return;
      if (!ok) {
        setState(() {});
        return;
      }
      HapticFeedback.lightImpact();
      if (mounted && correction.inserted) {
        await _showBalanceCorrectionDialog(
          context,
          previousBook: previousBook,
          newBook: balance,
          account: acc,
          correction: correction,
        );
      }
      if (mounted) Navigator.pop(context, acc);
    } else {
      Navigator.pop(
        context,
        Account(
          name: name,
          institution: institution,
          group: _group,
          iconCodePoint: _iconCodePoint,
          colorArgb: _colorArgb,
          balance: balance,
          overdraftLimit: overdraft,
          currencyCode: _currencyCode,
        ),
      );
    }
  }

  String _groupDescriptionL10n(BuildContext context) => switch (_group) {
        AccountGroup.personal => AppLocalizations.of(context).groupDescPersonal,
        AccountGroup.individuals => AppLocalizations.of(context).groupDescIndividuals,
        AccountGroup.entities => AppLocalizations.of(context).groupDescEntities,
      };

  void _confirmArchiveSheet() {
    final acc = widget.account!;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    if (acc.archived) return;
    if (!canArchiveAccount(acc)) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.cannotArchiveTitle),
          content: Text(l10n.cannotArchiveBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }
    final nPlanned = plannedReferenceCount(acc, data.plannedTransactions);
    Future<void> finish() async {
      final wasArchived = acc.archived;
      acc.archived = true;
      if (!await guardPersist(
          context, () => DataRepository.persistAccountFields(acc))) {
        acc.archived = wasArchived;
        if (mounted) setState(() {});
        return;
      }
      if (mounted) Navigator.pop(context, acc);
    }
    if (nPlanned > 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.archiveAccountTitle),
          content: Text(l10n.archiveWithPlannedBody(nPlanned)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final wasArchived = acc.archived;
                final ok = await guardPersist(context, () async {
                  await DataRepository.removePlannedReferencingAccount(acc);
                  acc.archived = true;
                  await DataRepository.persistAccountFields(acc);
                });
                if (!ok) {
                  acc.archived = wasArchived;
                  if (mounted) setState(() {});
                  return;
                }
                if (mounted) Navigator.pop(context, acc);
              },
              child: Text(l10n.removeAndArchive),
            ),
          ],
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.archiveAccountTitle),
        content: Text(l10n.archiveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await finish();
            },
            child: Text(l10n.archiveAction),
          ),
        ],
      ),
    );
  }

  void _delete() {
    final acc = widget.account!;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    if (accountReferencedInTrack(acc, data.transactions)) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.cannotDeleteTitle),
          content: Text(l10n.cannotDeleteBodyHistory),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }
    final nPlanned = plannedReferenceCount(acc, data.plannedTransactions);
    if (nPlanned > 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.deleteAccountTitle),
          content: Text(l10n.deleteWithPlannedBody(nPlanned)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                if (!await guardPersist(context, () async {
                  await DataRepository.removePlannedReferencingAccount(acc);
                  await DataRepository.removeAccount(acc);
                })) {
                  if (mounted) setState(() {});
                  return;
                }
                if (mounted) {
                  Navigator.pop(context, kAccountFormSheetDeleted);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
                foregroundColor: Theme.of(ctx).colorScheme.onError,
              ),
              child: Text(l10n.deleteAllAndDelete),
            ),
          ],
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountBodyPermanent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (!await guardPersist(
                  context, () => DataRepository.removeAccount(acc))) {
                if (mounted) setState(() {});
                return;
              }
              if (mounted) {
                Navigator.pop(context, kAccountFormSheetDeleted);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.account != null;

    return PopScope(
      canPop: !_isDirty || _forceClose,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showDiscardDialog();
      },
      child: Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(isEdit ? l10n.editAccountTitle : l10n.newAccountTitle,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      if (_isDirty) {
                        _showDiscardDialog();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SegmentedButton<AccountGroup>(
                segments: [
                  ButtonSegment(
                    value: AccountGroup.personal,
                    icon: const Icon(Icons.account_balance_wallet_outlined,
                        size: 16),
                    label: Text(l10n.accountGroupPersonal),
                  ),
                  ButtonSegment(
                    value: AccountGroup.individuals,
                    icon: const Icon(Icons.person_outline_rounded, size: 16),
                    label: Text(l10n.accountGroupIndividual),
                  ),
                  ButtonSegment(
                    value: AccountGroup.entities,
                    icon: const Icon(Icons.business_outlined, size: 16),
                    label: Text(l10n.accountGroupEntity),
                  ),
                ],
                selected: {_group},
                onSelectionChanged: (s) {
                  final ng = s.first;
                  setState(() {
                    _group = ng;
                    if (!_accountGroupAllowsOverdraft(ng)) {
                      _overdraftController.clear();
                    }
                  });
                },
              ),
              const SizedBox(height: 6),
              Text(
                _groupDescriptionL10n(context),
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                autofocus: !isEdit,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.labelAccountName,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _institutionController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.labelAccountIdentifier,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              _accountAppearanceEditorBlock(
                context,
                previewAccount: _previewAccountForSheet(),
                onPickIcon: _pickIconForSheet,
                onPickColor: _pickColorForSheet,
              ),
              const SizedBox(height: 16),

              // Currency — editable only when creating
              if (!isEdit)
                _CurrencyTile(
                  currencyCode: _currencyCode,
                  onTap: _pickCurrency,
                )
              else
                _CurrencyTile(currencyCode: _currencyCode, onTap: null),
              const SizedBox(height: 12),

              TextField(
                controller: _balanceController,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                decoration: InputDecoration(
                  labelText: l10n.labelRealBalance,
                  suffixText: ' ${fx.currencySymbol(_currencyCode)}',
                ),
              ),
              if (_accountGroupAllowsOverdraft(_group)) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _overdraftController,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  decoration: InputDecoration(
                    labelText: l10n.labelOverdraftLimit,
                    suffixText: ' ${fx.currencySymbol(_currencyCode)}',
                  ),
                ),
              ],
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => _save(),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(isEdit ? l10n.saveChanges : l10n.addAccountAction,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
              ),
              if (isEdit) ...[
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed:
                      widget.account!.archived ? null : _confirmArchiveSheet,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  child: Text(l10n.archiveAction),
                ),
                const SizedBox(height: 6),
                TextButton.icon(
                  onPressed: _delete,
                  icon: const Icon(Icons.delete_outline_rounded,
                      size: 18),
                  label: Text(l10n.deletePermanently),
                  style: TextButton.styleFrom(
                    foregroundColor: cs.error,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      ),
    );
  }
}

// ─── Account Form Screen (full-screen push) ──────────────────────────────────

class AccountFormScreen extends StatefulWidget {
  final Account? existing;
  final AccountGroup? initialGroup;
  const AccountFormScreen({super.key, this.existing, this.initialGroup});

  @override
  State<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends State<AccountFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _institutionController;
  late final TextEditingController _balanceController;
  late final TextEditingController _overdraftController;
  late AccountGroup _group;
  late String _currencyCode;
  late int _iconCodePoint;
  int? _colorArgb;
  bool _forceClose = false;

  bool get _isEdit => widget.existing != null;

  double _parseOverdraftLimit() {
    final t = _overdraftController.text.trim();
    if (t.isEmpty) return 0;
    return (double.tryParse(t.replaceAll(',', '.')) ?? 0).clamp(0.0, 1e15);
  }

  double _effectiveOverdraftLimitForForm() =>
      _accountGroupAllowsOverdraft(_group) ? _parseOverdraftLimit() : 0.0;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existing?.name ?? '');
    _institutionController = TextEditingController(
      text: widget.existing?.institution ?? '',
    );
    _balanceController = TextEditingController(
      text: widget.existing != null
          ? widget.existing!.balance.toStringAsFixed(2)
          : '',
    );
    _group = widget.existing?.group ??
        widget.initialGroup ??
        AccountGroup.personal;
    _overdraftController = TextEditingController(
      text: widget.existing != null &&
              widget.existing!.overdraftLimit > 0 &&
              _accountGroupAllowsOverdraft(_group)
          ? widget.existing!.overdraftLimit.toStringAsFixed(2)
          : '',
    );
    _currencyCode =
        widget.existing?.currencyCode ?? settings.baseCurrency;
    _iconCodePoint = widget.existing?.iconCodePoint ?? 0;
    _colorArgb = widget.existing?.colorArgb;
  }

  String _trimmedInstitutionScreen() {
    final t = _institutionController.text.trim();
    return t.isEmpty ? '' : t;
  }

  Account _previewAccountForScreen() {
    final name = _nameController.text.trim();
    final inst = _trimmedInstitutionScreen();
    return Account(
      id: widget.existing?.id ?? 'preview',
      name: name.isEmpty ? '?' : name,
      institution: inst.isEmpty ? null : inst,
      group: _group,
      iconCodePoint: _iconCodePoint,
      colorArgb: _colorArgb,
      currencyCode: _currencyCode,
    );
  }

  Future<void> _pickIconForScreen() async {
    final v =
        await _pickAccountIconCodePoint(context, current: _iconCodePoint);
    if (!mounted || v == null) return;
    setState(() => _iconCodePoint = v);
  }

  Future<void> _pickColorForScreen() async {
    final v = await _pickAccountColorArgb(context, current: _colorArgb);
    if (!mounted || v == null) return;
    setState(() => _colorArgb = v < 0 ? null : v);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _institutionController.dispose();
    _balanceController.dispose();
    _overdraftController.dispose();
    super.dispose();
  }

  bool get _isDirty {
    final inst = _trimmedInstitutionScreen();
    final instExisting = widget.existing?.institution?.trim() ?? '';
    final instNorm = inst.isEmpty ? '' : inst;
    if (_isEdit) {
      return _nameController.text.trim() != widget.existing!.name ||
          instNorm != instExisting ||
          _balanceController.text.trim() !=
              widget.existing!.balance.toStringAsFixed(2) ||
          _group != widget.existing!.group ||
          _effectiveOverdraftLimitForForm() !=
              widget.existing!.overdraftLimit ||
          _iconCodePoint != widget.existing!.iconCodePoint ||
          _colorArgb != widget.existing!.colorArgb;
    }
    final defaultGroup = widget.initialGroup ?? AccountGroup.personal;
    return _nameController.text.trim().isNotEmpty ||
        _balanceController.text.trim().isNotEmpty ||
        (_accountGroupAllowsOverdraft(_group) &&
            _parseOverdraftLimit() > 0) ||
        _currencyCode != settings.baseCurrency ||
        _group != defaultGroup ||
        instNorm.isNotEmpty ||
        _iconCodePoint != 0 ||
        _colorArgb != null;
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty;

  void _showDiscardDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.discardTitle),
        content: Text(l10n.discardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.keepEditing),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            child: Text(l10n.discard),
          ),
        ],
      ),
    ).then((discard) {
      if (discard == true && mounted) {
        setState(() => _forceClose = true);
        Navigator.of(context).pop();
      }
    });
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final instRaw = _trimmedInstitutionScreen();
    final institution = instRaw.isEmpty ? null : instRaw;
    if (isAccountDuplicate(
      name,
      institution,
      data.accounts,
      exceptAccountId: _isEdit ? widget.existing!.id : null,
    )) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).accountNameTaken,
          ),
        ),
      );
      return;
    }
    final balance =
        double.tryParse(_balanceController.text.trim().replaceAll(',', '.')) ??
            0.0;
    final overdraft = _effectiveOverdraftLimitForForm();
    if (_isEdit) {
      final acc = widget.existing!;
      final previousBook = acc.balance;
      final previousGroup = acc.group;
      acc.name = name;
      acc.institution = institution;
      acc.group = _group;
      if (previousGroup != _group) {
        acc.sortOrder = DataRepository.nextSortOrderInGroup(
          acc.group,
          excludeAccountId: acc.id,
        );
      }
      acc.overdraftLimit = overdraft;
      acc.iconCodePoint = _iconCodePoint;
      acc.colorArgb = _colorArgb;

      late BalanceCorrectionResult correction;
      final ok = await guardPersist(context, () async {
        correction = await applyLedgerBalanceCorrection(
          account: acc,
          previousBookBalance: previousBook,
          newBookBalance: balance,
        );
        if (!correction.inserted) {
          acc.balance = balance;
        }
        await DataRepository.persistAccountFields(acc);
      });
      if (!mounted) return;
      if (!ok) {
        setState(() {});
        return;
      }
      HapticFeedback.lightImpact();
      if (mounted && correction.inserted) {
        await _showBalanceCorrectionDialog(
          context,
          previousBook: previousBook,
          newBook: balance,
          account: acc,
          correction: correction,
        );
      }
      if (mounted) Navigator.pop(context, true);
    } else {
      final ok = await guardPersist(context, () => DataRepository.addAccount(
            Account(
              name: name,
              institution: institution,
              group: _group,
              iconCodePoint: _iconCodePoint,
              colorArgb: _colorArgb,
              balance: balance,
              overdraftLimit: overdraft,
              currencyCode: _currencyCode,
            ),
          ));
      if (!mounted) return;
      if (!ok) {
        setState(() {});
        return;
      }
      HapticFeedback.lightImpact();
      if (mounted) Navigator.pop(context, true);
    }
  }

  Future<void> _restoreArchived() async {
    final acc = widget.existing!;
    final wasArchived = acc.archived;
    acc.archived = false;
    if (!await guardPersist(context, () => DataRepository.persistAccountFields(acc))) {
      acc.archived = wasArchived;
      if (mounted) setState(() {});
      return;
    }
    setState(() {});
  }

  void _confirmArchive() {
    final acc = widget.existing!;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    if (acc.archived) return;
    if (!canArchiveAccount(acc)) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.cannotArchiveTitle),
          content: Text(l10n.cannotArchiveBodyAdjust),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }
    final nPlanned = plannedReferenceCount(acc, data.plannedTransactions);
    Future<void> finishArchive() async {
      final wasArchived = acc.archived;
      acc.archived = true;
      if (!await guardPersist(
          context, () => DataRepository.persistAccountFields(acc))) {
        acc.archived = wasArchived;
        if (mounted) setState(() {});
        return;
      }
      if (mounted) Navigator.pop(context, true);
    }

    if (nPlanned > 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.archiveAccountTitle),
          content: Text(l10n.archiveWithPlannedBody(nPlanned)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final wasArchived = acc.archived;
                final ok = await guardPersist(context, () async {
                  await DataRepository.removePlannedReferencingAccount(acc);
                  acc.archived = true;
                  await DataRepository.persistAccountFields(acc);
                });
                if (!ok) {
                  acc.archived = wasArchived;
                  if (mounted) setState(() {});
                  return;
                }
                if (mounted) Navigator.pop(context, true);
              },
              child: Text(l10n.removeAndArchive),
            ),
          ],
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.archiveAccountTitle),
        content: Text(l10n.archiveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await finishArchive();
            },
            child: Text(l10n.archiveAction),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    final acc = widget.existing!;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    if (accountReferencedInTrack(acc, data.transactions)) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.cannotDeleteTitle),
          content: Text(
            acc.archived
                ? l10n.cannotDeleteBodyShort
                : l10n.cannotDeleteBodySuggestArchive,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.close),
            ),
            if (!acc.archived)
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _confirmArchive();
                },
                child: Text(l10n.archiveInstead),
              ),
          ],
        ),
      );
      return;
    }
    final nPlanned = plannedReferenceCount(acc, data.plannedTransactions);
    if (nPlanned > 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.deleteAccountTitle),
          content: Text(l10n.deleteWithPlannedBody(nPlanned)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                if (!await guardPersist(context, () async {
                  await DataRepository.removePlannedReferencingAccount(acc);
                  await DataRepository.removeAccount(acc);
                })) {
                  if (mounted) setState(() {});
                  return;
                }
                if (mounted) {
                  Navigator.pop(context, kAccountFormSheetDeleted);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
                foregroundColor: Theme.of(ctx).colorScheme.onError,
              ),
              child: Text(l10n.deleteAllAndDelete),
            ),
          ],
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountBodyPermanent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (!await guardPersist(
                  context, () => DataRepository.removeAccount(acc))) {
                if (mounted) setState(() {});
                return;
              }
              if (mounted) {
                Navigator.pop(context, kAccountFormSheetDeleted);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCurrency() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _CurrencyPickerSheet(selected: _currencyCode),
    );
    if (result != null && mounted) setState(() => _currencyCode = result);
  }

  String _groupDescriptionL10n(BuildContext context) => switch (_group) {
        AccountGroup.personal => AppLocalizations.of(context).groupDescPersonal,
        AccountGroup.individuals => AppLocalizations.of(context).groupDescIndividuals,
        AccountGroup.entities => AppLocalizations.of(context).groupDescEntities,
      };

  void _showRemoveAccountSheet() {
    HapticFeedback.lightImpact();
    final acc = widget.existing!;
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(
                  l10n.removeAccountSheetTitle,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.delete_outline_rounded, color: cs.error),
                title: Text(
                  l10n.deletePermanently,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: cs.error,
                  ),
                ),
                subtitle: Text(l10n.deletePermanentlySubtitle),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete();
                },
              ),
              if (!acc.archived)
                ListTile(
                  leading: Icon(Icons.inventory_2_outlined, color: cs.primary),
                  title: Text(
                    l10n.archiveAction,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(l10n.archiveOptionSubtitle),
                  onTap: () {
                    Navigator.pop(ctx);
                    _confirmArchive();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: !_isDirty || _forceClose,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showDiscardDialog();
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          title: Text(_isEdit ? l10n.editAccountTitle : l10n.newAccountTitle),
          centerTitle: false,
          backgroundColor: cs.surface,
          surfaceTintColor: Colors.transparent,
          actions: _isEdit
              ? [
                  IconButton(
                    icon: Icon(Icons.delete_outline_rounded, color: cs.error),
                    tooltip: l10n.tooltipRemoveAccount,
                    onPressed: _showRemoveAccountSheet,
                  ),
                ]
              : null,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_isEdit && widget.existing!.archived)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Material(
                          color: cs.secondaryContainer
                              .withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.inventory_2_outlined,
                                    size: 22, color: cs.onSecondaryContainer),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.archivedBannerText,
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.35,
                                      color: cs.onSecondaryContainer,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _restoreArchived(),
                                  child: Text(l10n.restore),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    SegmentedButton<AccountGroup>(
                      segments: [
                        ButtonSegment(
                          value: AccountGroup.personal,
                          icon: const Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 16),
                          label: Text(l10n.accountGroupPersonal),
                        ),
                        ButtonSegment(
                          value: AccountGroup.individuals,
                          icon: const Icon(Icons.person_outline_rounded, size: 16),
                          label: Text(l10n.accountGroupIndividual),
                        ),
                        ButtonSegment(
                          value: AccountGroup.entities,
                          icon: const Icon(Icons.business_outlined, size: 16),
                          label: Text(l10n.accountGroupEntity),
                        ),
                      ],
                      selected: {_group},
                      onSelectionChanged: (s) {
                        final ng = s.first;
                        setState(() {
                          _group = ng;
                          if (!_accountGroupAllowsOverdraft(ng)) {
                            _overdraftController.clear();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _groupDescriptionL10n(context),
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      autofocus: !_isEdit,
                      textCapitalization: TextCapitalization.words,
                      decoration:
                          InputDecoration(labelText: l10n.labelAccountName),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _institutionController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: l10n.labelAccountIdentifier,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    _accountAppearanceEditorBlock(
                      context,
                      previewAccount: _previewAccountForScreen(),
                      onPickIcon: _pickIconForScreen,
                      onPickColor: _pickColorForScreen,
                    ),
                    const SizedBox(height: 16),
                    if (!_isEdit)
                      _CurrencyTile(
                          currencyCode: _currencyCode, onTap: _pickCurrency)
                    else
                      _CurrencyTile(
                          currencyCode: _currencyCode, onTap: null),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _balanceController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      decoration: InputDecoration(
                        labelText: l10n.labelRealBalance,
                        suffixText:
                            '  ${fx.currencySymbol(_currencyCode)}',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    if (_accountGroupAllowsOverdraft(_group)) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _overdraftController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        decoration: InputDecoration(
                          labelText: l10n.labelOverdraftLimit,
                          suffixText:
                              '  ${fx.currencySymbol(_currencyCode)}',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  16, 10, 16, MediaQuery.of(context).padding.bottom + 10),
              decoration: BoxDecoration(
                color: cs.surface,
                border: Border(
                    top: BorderSide(
                        color: cs.outlineVariant.withValues(alpha: 0.4),
                        width: 0.5)),
              ),
              child: FilledButton(
                onPressed: _canSave ? () => _save() : null,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(_isEdit ? l10n.saveChanges : l10n.addAccountAction,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Currency picker tile ────────────────────────────────────────────────────

class _CurrencyTile extends StatelessWidget {
  final String currencyCode;
  final VoidCallback? onTap;

  const _CurrencyTile({required this.currencyCode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final name =
        currencyDisplayName(currencyCode, Localizations.localeOf(context));
    final symbol = fx.currencySymbol(currencyCode);
    final enabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.labelCurrency,
          suffixIcon: enabled
              ? const Icon(Icons.arrow_drop_down_rounded)
              : Icon(Icons.lock_outline_rounded,
                  size: 16, color: cs.onSurfaceVariant),
          enabled: enabled,
        ),
        child: Text(
          '$currencyCode  ·  $symbol  ·  $name',
          style: TextStyle(
            fontSize: 14,
            color: enabled ? cs.onSurface : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ─── Currency picker bottom sheet ───────────────────────────────────────────

class _CurrencyPickerSheet extends StatefulWidget {
  final String selected;
  const _CurrencyPickerSheet({required this.selected});

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  final _searchController = TextEditingController();
  List<String> _filtered = settings.supportedCurrencies;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final q = query.toLowerCase().trim();
    final locale = Localizations.localeOf(context);
    setState(() {
      _filtered = q.isEmpty
          ? settings.supportedCurrencies
          : settings.supportedCurrencies.where((code) {
              final name = currencyDisplayName(code, locale).toLowerCase();
              return code.toLowerCase().contains(q) || name.contains(q);
            }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).searchCurrencies,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _searchController.clear();
                            _onSearch('');
                          },
                        )
                      : null,
                  isDense: true,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (ctx, i) {
                  final code = _filtered[i];
                  final name = currencyDisplayName(
                      code, Localizations.localeOf(ctx));
                  final symbol = fx.currencySymbol(code);
                  final isSelected = code == widget.selected;
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: isSelected
                          ? cs.primaryContainer
                          : cs.surfaceContainerHighest,
                      child: Text(
                        symbol.length <= 2 ? symbol : code.substring(0, 1),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? cs.onPrimaryContainer
                              : cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    title: Text(
                      '$code  —  $name',
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      symbol,
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_rounded, color: cs.primary)
                        : null,
                    onTap: () => Navigator.pop(ctx, code),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
