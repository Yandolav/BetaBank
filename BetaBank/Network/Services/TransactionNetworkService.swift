import Foundation

protocol TransactionNetworkServiceProtocol {
    func getAllTransactions() async -> Result<[TransactionDTO], Error>
    func saveTransaction(_ transaction: TransactionDTO) async -> Result<[TransactionDTO], Error>
    func updateTransaction(_ transaction: TransactionDTO) async -> Result<[TransactionDTO], Error>
}

final class TransactionNetworkService: TransactionNetworkServiceProtocol {

    private let client: NetworkClientProtocol
    private let storage: any TransactionStorageProtocol
    private let baseURL = "https://alfaitmo.ru/server/echo/409950/transactions"

    init(client: NetworkClientProtocol, storage: any TransactionStorageProtocol) {
        self.client = client
        self.storage = storage
    }

    func getAllTransactions() async -> Result<[TransactionDTO], Error> {
        let result: Result<[TransactionDTO], Error> = await client.get(url: baseURL)

        switch result {
        case .success(let dtos):
            dtos.forEach { _ = storage.upsert(entity: $0.toDomain()) }
            return .success(dtos)
        case .failure:
            let cached = storage.fetchAll().map { TransactionDTO(from: $0) }
            return cached.isEmpty ? result : .success(cached)
        }
    }

    func saveTransaction(_ transaction: TransactionDTO) async -> Result<[TransactionDTO], Error> {
        var transactions: [TransactionDTO] = []
        if case .success(let dtos) = await getAllTransactions() {
            transactions = dtos
        }

        transactions.append(transaction)

        let result: Result<[TransactionDTO], Error> = await client.post(url: baseURL, body: transactions)

        if case .success = result {
            _ = storage.upsert(entity: transaction.toDomain())
        }
        return result
    }

    func updateTransaction(_ transaction: TransactionDTO) async -> Result<[TransactionDTO], Error> {
        var transactions: [TransactionDTO] = []
        if case .success(let dtos) = await getAllTransactions() {
            transactions = dtos
        }

        guard let index = transactions.firstIndex(where: { $0.id == transaction.id }) else {
            return .failure(NetworkError.notFound)
        }

        transactions[index] = transaction

        let result: Result<[TransactionDTO], Error> = await client.post(url: baseURL, body: transactions)

        if case .success = result {
            _ = storage.upsert(entity: transaction.toDomain())
        }
        return result
    }
}
