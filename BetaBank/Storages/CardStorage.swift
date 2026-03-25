import Foundation

protocol CardStorageProtocol: Storage where Entity == Card { }

final class CardStorage: CardStorageProtocol {

    private let fileName = "cards"
    private let store: CodableStore
    private var cards: [Card]

    init(store: CodableStore) {
        self.store = store
        self.cards = store.load([Card].self, fileName: fileName, defaultValue: [])
    }

    func fetch(id: UUID) -> Result<Card, Error> {
        guard let card = cards.first(where: {$0.id == id}) else {
            return .failure(StorageError.incorrectId)
        }
        return .success(card)
    }

    func fetchAll() -> [Card] {
        cards
    }

    func create(entity: Card) -> Result<Void, Error> {
        guard !cards.contains(where: { $0.id == entity.id }) else {
            return .failure(StorageError.existingEntity)
        }

        cards.append(entity)
        return store.save(cards, fileName: fileName)
    }

    func delete(id: UUID) -> Result<Void, Error> {
        guard let index = cards.firstIndex(where: {$0.id == id}) else {
            return .failure(StorageError.incorrectId)
        }

        cards.remove(at: index)
        return store.save(cards, fileName: fileName)
    }

    func update(id: UUID, entity: Card) -> Result<Void, Error> {
        guard let index = cards.firstIndex(where: {$0.id == id}) else {
            return .failure(StorageError.incorrectId)
        }

        cards[index] = entity
        return store.save(cards, fileName: fileName)
    }

    func upsert(entity: Card) -> Result<Void, Error> {
        switch fetch(id: entity.id) {
        case .success: return update(id: entity.id, entity: entity)
        case .failure: return create(entity: entity)
        }
    }
}
