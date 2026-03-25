import Foundation

struct CardCellViewModel: Equatable {
    let id: UUID
    let balance: Int
    let number: String
    let userFullName: String
    let validatePeriod: Date
    let bankName: String
    let code: String
}
