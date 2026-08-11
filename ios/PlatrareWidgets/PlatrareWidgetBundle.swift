import SwiftUI
import WidgetKit

@main
struct PlatrareWidgetBundle: WidgetBundle {
    var body: some Widget {
        PlatrareQuickAddWidget()
        PlatrareNumbersWidget()
        // Control Center / Action Button, iOS 18+. WidgetBundleBuilder handles
        // the availability split so the appex still loads on iOS 17.
        if #available(iOS 18.0, *) {
            PlatrareAddControl()
            PlatrarePlanControl()
        }
    }
}
