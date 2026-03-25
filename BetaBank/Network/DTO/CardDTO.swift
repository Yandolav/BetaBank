import Foundation

struct CardDTO: Codable {
    let id: UUID
    let userID: UUID
    let balance: Int
    let number: String
    let userFullName: String
    let validatePeriod: Date
    let bankName: String
    let code: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case balance
        case number
        case userFullName = "user_full_name"
        case validatePeriod = "validate_period"
        case bankName = "bank_name"
        case code
    }
}

extension CardDTO {
    init(from card: Card) {
        self.id = card.id
        self.userID = card.userID
        self.balance = card.balance
        self.number = card.number
        self.userFullName = card.userFullName
        self.validatePeriod = card.validatePeriod
        self.bankName = card.bankName
        self.code = card.code
    }

    func toDomain() -> Card {
        Card(
            id: id,
            userID: userID,
            balance: balance,
            number: number,
            userFullName: userFullName,
            validatePeriod: validatePeriod,
            bankName: bankName,
            code: code
        )
    }
}
