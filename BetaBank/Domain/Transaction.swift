import Foundation

struct Transaction: Identifiable, Codable, Hashable {
    let id: UUID
    let date: Date
    let amountMinor: Int
    let direction: Direction
    let status: Status
    let comment: String?
    let fromCard: UUID
    let toCard: UUID

    var signedAmountMinor: Int {
        direction == .debit ? -amountMinor : amountMinor
    }
}

// MARK: - Enums

extension Transaction {
    enum Direction: String, Codable {
        case debit
        case credit
    }

    enum Status: String, Codable {
        case success
        case failed
    }
}
