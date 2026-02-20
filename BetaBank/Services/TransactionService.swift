import Foundation

protocol TransactionServiceProtocol {
    func getTransaction(transactionId: UUID) -> Result<Transaction, Error>

    func getAllTransactions(userId: UUID) -> Result<[Transaction], Error>

    func createTransaction(
        amountMinor: Int,
        direction: Transaction.Direction,
        status: Transaction.Status,
        title: String,
        comment: String?,
        fromCard: UUID,
        toCard: UUID
    ) -> Result<Void, Error>

    func deleteTransaction(transactionId: UUID) -> Result<Void, Error>
}

final class TransactionService {

    // MARK: Private properties

    private let transactionStorage: any TransactionStorageProtocol

    // MARK: Init

    init(transactionStorage: any TransactionStorageProtocol) {
        self.transactionStorage = transactionStorage
    }
}

// MARK: - TransactionServiceProtocol

extension TransactionService: TransactionServiceProtocol {
    func getTransaction(transactionId: UUID) -> Result<Transaction, Error> {
        .failure(StorageError.existingEntity)
    }
    
    func getAllTransactions(userId: UUID) -> Result<[Transaction], Error> {
        .failure(StorageError.existingEntity)
    }

    func createTransaction(
        amountMinor: Int,
        direction: Transaction.Direction,
        status: Transaction.Status,
        title: String,
        comment: String?,
        fromCard from: UUID,
        toCard to: UUID
    ) -> Result<Void, Error> {
        .failure(StorageError.existingEntity)
    }

    func deleteTransaction(transactionId: UUID) -> Result<Void, Error> {
        .failure(StorageError.existingEntity)
    }
}

// MARK: - TransactionServiceError

extension TransactionService {
    enum TransactionServiceError: Error, LocalizedError {
        case transactionNotFound(transactionId: UUID)
        case userNotFound(userId: UUID)
        case cardNotFound(cardId: UUID)
        case invalidAmount
        case emptyTitle
        case sameCardTransfer
        case invalidStatus
        case insufficientFunds(currentBalanceMinor: Int, requiredMinor: Int)
        case cardBlocked(cardId: UUID)
        case cardExpired(cardId: UUID)
        case dailyLimitExceeded(limitMinor: Int, attemptedMinor: Int)
        case failedToLoadTransactions
        case failedToSaveTransaction
        case failedToDeleteTransaction
        case unknown(underlying: Error)

        var errorDescription: String? {
            switch self {
            case .transactionNotFound(let id):
                return "Транзакция с id \(id.uuidString) не найдена."
            case .userNotFound(let id):
                return "Пользователь с id \(id.uuidString) не найден."
            case .cardNotFound(let id):
                return "Карта с id \(id.uuidString) не найдена."
            case .invalidAmount:
                return "Сумма транзакции должна быть больше нуля."
            case .emptyTitle:
                return "Название транзакции не может быть пустым."
            case .sameCardTransfer:
                return "Нельзя выполнить перевод на ту же самую карту."
            case .invalidStatus:
                return "Некорректный статус транзакции."
            case .insufficientFunds(let current, let required):
                return "Недостаточно средств. Доступно: \(current), требуется: \(required)."
            case .cardBlocked(let id):
                return "Операция невозможна: карта \(id.uuidString) заблокирована."
            case .cardExpired(let id):
                return "Операция невозможна: карта \(id.uuidString) просрочена."
            case .dailyLimitExceeded(let limit, let attempted):
                return "Превышен дневной лимит. Лимит: \(limit), попытка: \(attempted)."
            case .failedToLoadTransactions:
                return "Не удалось получить список транзакций."
            case .failedToSaveTransaction:
                return "Не удалось сохранить транзакцию."
            case .failedToDeleteTransaction:
                return "Не удалось удалить транзакцию."
            case .unknown(let underlying):
                return "Неизвестная ошибка: \(underlying.localizedDescription)"
            }
        }
    }
}

