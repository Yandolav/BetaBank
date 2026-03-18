import Foundation

struct TransactionDTO: Codable {
    let id: UUID
    let date: Date
    let amountMinor: Int
    let direction: String
    let status: String
    let comment: String?
    let fromCard: UUID
    let toCard: UUID

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case amountMinor = "amount_minor"
        case direction
        case status
        case comment
        case fromCard = "from_card"
        case toCard = "to_card"
    }
}

extension TransactionDTO {
    init(from transaction: Transaction) {
        self.id = transaction.id
        self.date = transaction.date
        self.amountMinor = transaction.amountMinor
        self.direction = transaction.direction.rawValue
        self.status = transaction.status.rawValue
        self.comment = transaction.comment
        self.fromCard = transaction.fromCard
        self.toCard = transaction.toCard
    }

    func toDomain() -> Transaction {
        Transaction(
            id: id,
            date: date,
            amountMinor: amountMinor,
            direction: Transaction.Direction(rawValue: direction) ?? .debit,
            status: Transaction.Status(rawValue: status) ?? .failed,
            comment: comment,
            fromCard: fromCard,
            toCard: toCard
        )
    }
}
