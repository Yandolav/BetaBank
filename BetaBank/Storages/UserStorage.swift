import Foundation

protocol UserStorageProtocol: Storage where Entity == User { }

final class UserStorage: UserStorageProtocol {

    private let fileName = "users"
    private let store: CodableStore
    private var users: [User]

    init(store: CodableStore) {
        self.store = store
        self.users = store.load([User].self, fileName: fileName, defaultValue: [])
    }

    func fetch(id: UUID) -> Result<User, Error> {
        guard let user = users.first(where: {$0.id == id}) else {
            return .failure(StorageError.incorrectId)
        }
        return .success(user)
    }

    func fetchAll() -> [User] {
        users
    }

    func create(entity: User) -> Result<Void, Error> {
        guard !users.contains(where: { $0.id == entity.id }) else {
            return .failure(StorageError.existingEntity)
        }

        users.append(entity)
        return store.save(users, fileName: fileName)
    }

    func delete(id: UUID) -> Result<Void, Error> {
        guard let index = users.firstIndex(where: {$0.id == id}) else {
            return .failure(StorageError.incorrectId)
        }

        users.remove(at: index)
        return store.save(users, fileName: fileName)
    }

    func update(id: UUID, entity: User) -> Result<Void, Error> {
        guard let index = users.firstIndex(where: {$0.id == id}) else {
            return .failure(StorageError.incorrectId)
        }

        users[index] = entity
        return store.save(users, fileName: fileName)
    }

    func upsert(entity: User) -> Result<Void, Error> {
        switch fetch(id: entity.id) {
        case .success: return update(id: entity.id, entity: entity)
        case .failure: return create(entity: entity)
        }
    }
}
