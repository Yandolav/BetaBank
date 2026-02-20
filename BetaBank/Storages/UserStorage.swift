import Foundation

protocol UserStorageProtocol: Storage where Entity == User { }

final class UserStorage: UserStorageProtocol {
    func fetch(id: UUID) throws -> User {
        throw StorageError.incorrectId
    }
    
    func fetchAll() throws -> [User] {
        throw StorageError.incorrectId
    }
    
    func create(entity: User) throws {
        throw StorageError.incorrectId
    }
    
    func delete(id: UUID) throws {
        throw StorageError.incorrectId
    }
    
    func update(id: UUID, entity: User) throws {
        throw StorageError.incorrectId
    }
}
