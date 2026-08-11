import AppIntents
import Foundation

/// Deep-link shapes understood by the Dart dispatcher. Kept in one place so
/// widget URLs, quick actions and App Intents cannot drift apart.
enum PlatrareLink {
    static func addTracked(src: String) -> String {
        "platrare://add/tracked?src=\(src)&n=\(UUID().uuidString)"
    }

    static func addPlanned(src: String) -> String {
        "platrare://add/planned?src=\(src)&n=\(UUID().uuidString)"
    }

    static func openTab(_ tab: String, src: String) -> String {
        "platrare://open?tab=\(tab)&src=\(src)&n=\(UUID().uuidString)"
    }

    static func account(_ id: String, src: String) -> String {
        "platrare://account/\(id)?src=\(src)&n=\(UUID().uuidString)"
    }
}

/// Opens the app on the new-transaction screen.
///
/// Available from Siri, the Shortcuts app, the iOS 18 Control Center control
/// and the Action Button. The account pickers live in the app, so this always
/// opens rather than trying to record anything headlessly.
@available(iOS 16.0, *)
struct AddTransactionIntent: AppIntent {
    static var title: LocalizedStringResource =
        LocalizedStringResource("intent.addTracked.title", defaultValue: "Add transaction")
    static var description = IntentDescription(
        LocalizedStringResource("intent.addTracked.desc",
                                defaultValue: "Record money you spent or received.")
    )
    static var openAppWhenRun = true
    static var isDiscoverable = true

    func perform() async throws -> some IntentResult {
        PlatrareLinkQueue.enqueue(PlatrareLink.addTracked(src: "intent"))
        return .result()
    }
}

/// Opens the app on the new-planned-transaction screen.
@available(iOS 16.0, *)
struct AddPlannedIntent: AppIntent {
    static var title: LocalizedStringResource =
        LocalizedStringResource("intent.addPlanned.title", defaultValue: "Add planned transaction")
    static var description = IntentDescription(
        LocalizedStringResource("intent.addPlanned.desc",
                                defaultValue: "Schedule a payment or income you expect.")
    )
    static var openAppWhenRun = true
    static var isDiscoverable = true

    func perform() async throws -> some IntentResult {
        PlatrareLinkQueue.enqueue(PlatrareLink.addPlanned(src: "intent"))
        return .result()
    }
}
