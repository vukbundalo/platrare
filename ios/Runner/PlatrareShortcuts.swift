import AppIntents

/// Siri phrases and Shortcuts-app entries.
///
/// Must live in the app target: the system reads exactly one
/// `AppShortcutsProvider` per app, from the main bundle.
///
/// Every phrase has to contain `\(.applicationName)` or the build fails.
/// Phrases localize through `AppShortcuts.xcstrings` in this target — a
/// separate surface from the ARB catalogue, kept in sync by
/// `tool/gen_ios_widget_strings.dart`.
@available(iOS 16.0, *)
struct PlatrareShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddTransactionIntent(),
            phrases: [
                "Add a transaction in \(.applicationName)",
                "Record an expense in \(.applicationName)",
                "New \(.applicationName) transaction",
            ],
            shortTitle: LocalizedStringResource("intent.addTracked.title",
                                                defaultValue: "Add transaction"),
            systemImageName: "plus.circle"
        )
        AppShortcut(
            intent: AddPlannedIntent(),
            phrases: [
                "Add a planned transaction in \(.applicationName)",
                "Plan a payment in \(.applicationName)",
            ],
            shortTitle: LocalizedStringResource("intent.addPlanned.title",
                                                defaultValue: "Add planned transaction"),
            systemImageName: "calendar.badge.plus"
        )
    }
}
