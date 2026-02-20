import Foundation

protocol TransactionStorageProtocol: Storage where Entity == Transaction { }

final class TransactionStorage: TransactionStorageProtocol {
    typealias Entity = Transaction

    func fetch(id: UUID) throws -> Transaction {
        throw StorageError.incorrectId
    }

    func fetchAll() throws -> [Transaction] {
        throw StorageError.incorrectId
    }

    func create(entity: Transaction) throws {
        throw StorageError.incorrectId
    }

    func delete(id: UUID) throws {
        throw StorageError.incorrectId
    }

    func update(id: UUID, entity: Transaction) throws {
        throw StorageError.incorrectId
    }
}
