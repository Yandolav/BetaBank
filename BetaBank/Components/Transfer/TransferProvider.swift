import Foundation

protocol TransferProviderProtocol: AnyObject {
    func submitTransfer(
        userId: UUID,
        amountMinor: Int,
        comment: String?,
        fromCard: UUID,
        toCard: UUID
    ) -> Result<Void, Error>

    func loadCards(userId: UUID) -> Result<[Card], Error>
}

final class TransferProvider {

    // MARK: Private properties

    private let transactionService: TransactionServiceProtocol
    private let cardService: CardServiceProtocol

    // MARK: Init

    init(transactionService: TransactionServiceProtocol, cardService: CardServiceProtocol) {
        self.transactionService = transactionService
        self.cardService = cardService
    }
}

// MARK: - TransferProviderProtocol

extension TransferProvider: TransferProviderProtocol {
    func submitTransfer(
        userId: UUID,
        amountMinor: Int,
        comment: String?,
        fromCard: UUID,
        toCard: UUID
    ) -> Result<Void, Error> {
        .success(())
    }

    func loadCards(userId: UUID) -> Result<[Card], Error> {
        .success([])
    }
}
