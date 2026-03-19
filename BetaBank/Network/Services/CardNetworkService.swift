import Foundation

protocol CardNetworkServiceProtocol {
    func getAllCards() async -> Result<[CardDTO], Error>
    func saveCard(_ card: CardDTO) async -> Result<[CardDTO], Error>
    func updateCard(_ card: CardDTO) async -> Result<[CardDTO], Error>
}

final class CardNetworkService: CardNetworkServiceProtocol {

    private let client: NetworkClientProtocol
    private let storage: any CardStorageProtocol
    private let baseURL = "https://alfaitmo.ru/server/echo/409950/cards"

    init(client: NetworkClientProtocol, storage: any CardStorageProtocol) {
        self.client = client
        self.storage = storage
    }

    func getAllCards() async -> Result<[CardDTO], Error> {
        let result: Result<[CardDTO], Error> = await client.get(url: baseURL)

        switch result {
        case .success(let dtos):
            dtos.forEach { _ = storage.upsert(entity: $0.toDomain()) }
            return .success(dtos)
        case .failure:
            let cached = storage.fetchAll().map { CardDTO(from: $0) }
            return cached.isEmpty ? result : .success(cached)
        }
    }

    func saveCard(_ card: CardDTO) async -> Result<[CardDTO], Error> {
        var cards: [CardDTO] = []
        if case .success(let dtos) = await getAllCards() {
            cards = dtos
        }

        cards.append(card)

        let result: Result<[CardDTO], Error> = await client.post(url: baseURL, body: cards)

        if case .success = result {
            _ = storage.upsert(entity: card.toDomain())
        }
        return result
    }

    func updateCard(_ card: CardDTO) async -> Result<[CardDTO], Error> {
        var cards: [CardDTO] = []
        if case .success(let dtos) = await getAllCards() {
            cards = dtos
        }

        guard let index = cards.firstIndex(where: { $0.id == card.id }) else {
            return .failure(NetworkError.notFound)
        }

        cards[index] = card

        let result: Result<[CardDTO], Error> = await client.post(url: baseURL, body: cards)

        if case .success = result {
            _ = storage.upsert(entity: card.toDomain())
        }
        return result
    }
}
