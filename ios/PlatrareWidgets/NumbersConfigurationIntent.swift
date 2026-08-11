import AppIntents
import WidgetKit

/// Per-instance configuration for the Numbers widget.
///
/// The parameter summary hides the pickers that do not apply: the account
/// picker only appears for `.account`, the horizon only for `.projected`.
@available(iOS 17.0, *)
struct NumbersConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource =
        LocalizedStringResource("config.title", defaultValue: "Balance")
    static var description = IntentDescription(
        LocalizedStringResource("config.desc", defaultValue: "Pick which figure to show.")
    )

    @Parameter(
        title: LocalizedStringResource("config.metric", defaultValue: "Metric"),
        default: .spendableNow
    )
    var metric: PlatrareMetric

    @Parameter(title: LocalizedStringResource("config.account", defaultValue: "Account"))
    var account: AccountEntity?

    @Parameter(
        title: LocalizedStringResource("config.horizon", defaultValue: "Horizon"),
        default: .endOfMonth
    )
    var horizon: PlatrareHorizon

    static var parameterSummary: some ParameterSummary {
        When(\.$metric, .equalTo, PlatrareMetric.account) {
            Summary {
                \.$metric
                \.$account
            }
        } otherwise: {
            When(\.$metric, .equalTo, PlatrareMetric.projected) {
                Summary {
                    \.$metric
                    \.$horizon
                }
            } otherwise: {
                Summary {
                    \.$metric
                }
            }
        }
    }

    init() {}
}
