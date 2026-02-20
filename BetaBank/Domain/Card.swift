import Foundation

struct Card: Identifiable, Codable {
    let id: UUID
    let userID: UUID
    let balance: Int
    let number: String
    let userFullName: String
    let validatePeriod: Date
    let bankName: String
    let code: String
}
