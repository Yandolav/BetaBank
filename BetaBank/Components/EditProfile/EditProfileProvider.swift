import Foundation

protocol EditProfileProviderProtocol: AnyObject {
    func updateUser(
        userId: UUID,
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        phone: String?,
        dataImage: Data?
    ) -> Result<User, Error>

    func getUser(userId: UUID) -> Result<User, Error>
}

final class EditProfileProvider {

    // MARK: Private properties

    private let userService: UserServiceProtocol

    // MARK: Init

    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
}

// MARK: - EditProfileProviderProtocol

extension EditProfileProvider: EditProfileProviderProtocol {
    func updateUser(
        userId: UUID,
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        phone: String?,
        dataImage: Data?
    ) -> Result<User, Error> {
        .success(User(
            id: UUID(),
            firstName: "",
            lastName: "",
            email: "",
            password: "",
            phone: "",
            dataImage: Data()
        ))
    }
    
    func getUser(userId: UUID) -> Result<User, Error> {
        .success(User(
            id: UUID(),
            firstName: "",
            lastName: "",
            email: "",
            password: "",
            phone: "",
            dataImage: Data()
        ))
    }
}

