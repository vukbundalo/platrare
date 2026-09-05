import AppIntents
import SwiftUI
import WidgetKit

/// Control Center control (iOS 18+).
///
/// The Action Button picks this up automatically once the control exists —
/// Settings → Action Button → Controls. No extra code for that path.
@available(iOS 18.0, *)
struct PlatrareAddControl: ControlWidget {
    static let kind = "com.platrare.app.control.addTransaction"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: AddTransactionIntent()) {
                Label(
                    String(localized: LocalizedStringResource("control.addTracked", defaultValue: "Add transaction")),
                    systemImage: "plus.circle.fill"
                )
            }
        }
        .displayName(
            LocalizedStringResource("control.addTracked", defaultValue: "Add transaction"))
        .description(
            LocalizedStringResource("control.addTracked.desc",
                                    defaultValue: "Record a transaction in Platrare."))
    }
}

/// Second control for the planned side, for users who schedule more than they
/// record ad hoc.
@available(iOS 18.0, *)
struct PlatrarePlanControl: ControlWidget {
    static let kind = "com.platrare.app.control.addPlanned"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: AddPlannedIntent()) {
                Label(
                    String(localized: LocalizedStringResource("control.addPlanned", defaultValue: "Add plan")),
                    systemImage: "calendar.badge.plus"
                )
            }
        }
        .displayName(
            LocalizedStringResource("control.addPlanned", defaultValue: "Add plan"))
        .description(
            LocalizedStringResource("control.addPlanned.desc",
                                    defaultValue: "Schedule a payment in Platrare."))
    }
}
