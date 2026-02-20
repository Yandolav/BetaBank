import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let phone: String?
    let dataImage: Data?
}
