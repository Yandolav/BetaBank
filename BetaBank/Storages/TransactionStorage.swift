import Foundation

protocol TransactionStorageProtocol: Storage where Entity == Transaction { }

final class TransactionStorage: TransactionStorageProtocol {

    private let fileName = "transactions"
    private let store: CodableStore
    private var transactions: [Transaction]

    init(store: CodableStore) {
        self.store = store
        self.transactions = store.load([Transaction].self, fileName: fileName, defaultValue: [])
    }

    func fetch(id: UUID) -> Result<Transaction, Error> {
        guard let Transaction = transactions.first(where: {$0.id == id}) else {
            return .failure(StorageError.incorrectId)
        }
        return .success(Transaction)
    }

    func fetchAll() -> [Transaction] {
        transactions
    }

    func create(entity: Transaction) -> Result<Void, Error> {
        guard !transactions.contains(where: { $0.id == entity.id }) else {
            return .failure(StorageError.existingEntity)
        }

        transactions.append(entity)
        return store.save(transactions, fileName: fileName)
    }

    func delete(id: UUID) -> Result<Void, Error> {
        guard let index = transactions.firstIndex(where: {$0.id == id}) else {
            return .failure(StorageError.incorrectId)
        }

        transactions.remove(at: index)
        return store.save(transactions, fileName: fileName)
    }

    func update(id: UUID, entity: Transaction) -> Result<Void, Error> {
        guard let index = transactions.firstIndex(where: {$0.id == id}) else {
            return .failure(StorageError.incorrectId)
        }

        transactions[index] = entity
        return store.save(transactions, fileName: fileName)
    }
}
