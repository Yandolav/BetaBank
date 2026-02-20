import Foundation

protocol CardStorageProtocol: Storage where Entity == Card { }

final class CardStorage: CardStorageProtocol {
    typealias Entity = Card

    func fetch(id: UUID) throws -> Card {
        throw StorageError.incorrectId
    }

    func fetchAll() throws -> [Card] {
        throw StorageError.incorrectId
    }

    func create(entity: Card) throws {
        throw StorageError.incorrectId
    }

    func delete(id: UUID) throws {
        throw StorageError.incorrectId
    }

    func update(id: UUID, entity: Card) throws {
        throw StorageError.incorrectId
    }
}

