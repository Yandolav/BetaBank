import Foundation

protocol TransactionDetailsProviderProtocol: AnyObject {
    func loadTransaction(transactionId: UUID) -> Result<Transaction, Error>
}

final class TransactionDetailsProvider {

    // MARK: Private properties

    private let transactionService: TransactionServiceProtocol

    // MARK: Init

    init(transactionService: TransactionServiceProtocol) {
        self.transactionService = transactionService
    }
}

// MARK: - TransactionDetailsProviderProtocol

extension TransactionDetailsProvider: TransactionDetailsProviderProtocol {
    func loadTransaction(transactionId: UUID) -> Result<Transaction, Error> {
        .success(Transaction(
            id: UUID(),
            date: Date(),
            amountMinor: 0,
            direction: .credit,
            status: .success,
            comment: "",
            fromCard: UUID(),
            toCard: UUID()
        ))
    }
}

