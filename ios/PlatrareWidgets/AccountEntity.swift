import AppIntents
import Foundation

/// An account the user can pick in the Numbers widget configuration sheet.
///
/// Backed entirely by the snapshot's `accounts[]`, so the picker works with
/// the app terminated and needs no IPC.
@available(iOS 17.0, *)
struct AccountEntity: AppEntity, Identifiable {
    let id: String
    let name: String
    let currency: String

    static var typeDisplayRepresentation = TypeDisplayRepresentation(
        name: LocalizedStringResource("entity.account", defaultValue: "Account")
    )

    static var defaultQuery = AccountEntityQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)", subtitle: "\(currency)")
    }

    init(id: String, name: String, currency: String) {
        self.id = id
        self.name = name
        self.currency = currency
    }

    init(_ info: Snapshot.AccountInfo) {
        self.init(id: info.id, name: info.displayName, currency: info.currency)
    }
}

/// `EntityStringQuery` rather than plain `EntityQuery` so Siri and Shortcuts
/// can resolve an account by typing or saying its name.
@available(iOS 17.0, *)
struct AccountEntityQuery: EntityStringQuery {
    private func all() -> [AccountEntity] {
        (SnapshotStore.load()?.accounts ?? []).map(AccountEntity.init)
    }

    func entities(for identifiers: [AccountEntity.ID]) async throws -> [AccountEntity] {
        let wanted = Set(identifiers)
        return all().filter { wanted.contains($0.id) }
    }

    func entities(matching string: String) async throws -> [AccountEntity] {
        guard !string.isEmpty else { return all() }
        return all().filter { $0.name.localizedCaseInsensitiveContains(string) }
    }

    func suggestedEntities() async throws -> [AccountEntity] {
        all()
    }

    /// First personal account, matching the app's own ordering.
    func defaultResult() async -> AccountEntity? {
        guard let snapshot = SnapshotStore.load() else { return nil }
        let personal = snapshot.accounts.first { $0.group == "personal" }
        return (personal ?? snapshot.accounts.first).map(AccountEntity.init)
    }
}
