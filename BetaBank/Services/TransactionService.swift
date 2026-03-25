import Foundation

protocol TransactionServiceProtocol {
    func getAllTransactions(userId: UUID) async -> Result<[Transaction], Error>
    func createTransaction(
        amountMinor: Int,
        direction: Transaction.Direction,
        status: Transaction.Status,
        comment: String?,
        fromCard: UUID,
        toCard: UUID
    ) async -> Result<Void, Error>
}

final class TransactionService {

    // MARK: Private properties

    private let networkService: any TransactionNetworkServiceProtocol
    private let cardNetworkService: any CardNetworkServiceProtocol

    // MARK: Init

    init(
        networkService: any TransactionNetworkServiceProtocol,
        cardNetworkService: any CardNetworkServiceProtocol
    ) {
        self.networkService = networkService
        self.cardNetworkService = cardNetworkService
    }

    // MARK: Private methods

    private func validateAmount(_ amount: Int) -> Result<Void, Error> {
        guard amount > 0 else { return .failure(TransactionServiceError.invalidAmount) }
        return .success(())
    }

    private func validateCards(from: UUID, to: UUID) -> Result<Void, Error> {
        guard from != to else { return .failure(TransactionServiceError.sameCardTransfer) }
        return .success(())
    }
}

// MARK: - TransactionServiceProtocol

extension TransactionService: TransactionServiceProtocol {

    func getAllTransactions(userId: UUID) async -> Result<[Transaction], Error> {
        let cardsResult = await cardNetworkService.getAllCards()

        var userCardIds: Set<UUID> = []
        if case .success(let cards) = cardsResult {
            userCardIds = Set(cards.filter { $0.userID == userId }.map { $0.id })
        }

        let result = await networkService.getAllTransactions()

        switch result {
        case .success(let dtos):
            let transactions = dtos
                .map { $0.toDomain() }
                .filter { userCardIds.contains($0.fromCard) || userCardIds.contains($0.toCard) }
            return .success(transactions)
        case .failure(let error):
            return .failure(error)
        }
    }

    func createTransaction(
        amountMinor: Int,
        direction: Transaction.Direction,
        status: Transaction.Status,
        comment: String?,
        fromCard: UUID,
        toCard: UUID
    ) async -> Result<Void, Error> {
        if case .failure(let error) = validateAmount(amountMinor) { return .failure(error) }
        if case .failure(let error) = validateCards(from: fromCard, to: toCard) { return .failure(error) }

        if direction == .debit {
            let cardsResult = await cardNetworkService.getAllCards()

            switch cardsResult {
            case .success(let cards):
                guard let card = cards.first(where: { $0.id == fromCard }) else {
                    return .failure(TransactionServiceError.cardNotFound)
                }
                guard card.balance >= amountMinor else {
                    return .failure(TransactionServiceError.insufficientFunds(
                        currentBalanceMinor: card.balance,
                        requiredMinor: amountMinor
                    ))
                }
            case .failure(let error):
                return .failure(error)
            }
        }

        let dto = TransactionDTO(
            id: UUID(),
            date: Date(),
            amountMinor: amountMinor,
            direction: direction.rawValue,
            status: status.rawValue,
            comment: comment,
            fromCard: fromCard,
            toCard: toCard
        )

        let result = await networkService.saveTransaction(dto)

        switch result {
        case .success: return .success(())
        case .failure(let error): return .failure(error)
        }
    }
}

// MARK: - TransactionServiceError

extension TransactionService {
    enum TransactionServiceError: Error, LocalizedError {
        case invalidAmount
        case sameCardTransfer
        case cardNotFound
        case insufficientFunds(currentBalanceMinor: Int, requiredMinor: Int)
        case unknown(underlying: Error)

        var errorDescription: String? {
            switch self {
            case .invalidAmount: return "Сумма транзакции должна быть больше нуля."
            case .sameCardTransfer: return "Нельзя выполнить перевод на ту же самую карту."
            case .cardNotFound: return "Карта не найдена."
            case .insufficientFunds(let current, let required): return "Недостаточно средств. Доступно: \(current), требуется: \(required)."
            case .unknown(let underlying): return "Неизвестная ошибка: \(underlying.localizedDescription)"
            }
        }
    }
}
