import Foundation

struct TransactionCellViewModel: Equatable {
    let id: UUID
    let date: Date
    let amountMinor: Int
    let direction: Transaction.Direction
    let status: Transaction.Status
    let comment: String?
}
