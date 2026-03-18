import Foundation

struct UserDTO: Codable {
    let id: UUID
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let phone: String?
    let dataImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case password
        case phone
        case dataImage = "data_image"
    }
}

extension UserDTO {
    init(from user: User) {
        self.id = user.id
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.email = user.email
        self.password = user.password
        self.phone = user.phone
        self.dataImage = user.dataImage?.base64EncodedString()
    }

    func toDomain() -> User {
        User(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            phone: phone,
            dataImage: dataImage.flatMap { Data(base64Encoded: $0) }
        )
    }
}
