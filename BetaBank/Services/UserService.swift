import Foundation

protocol UserServiceProtocol {
    func updateUser(
        userId: UUID,
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        phone: String?,
        dataImage: Data?
    ) async -> Result<User, Error>
    func getUser(userId: UUID) async -> Result<User, Error>
}

final class UserService {

    // MARK: Private properties

    private let networkService: UserNetworkServiceProtocol
    private let validator: ValidationWorker

    // MARK: Init

    init(networkService: UserNetworkServiceProtocol, validator: ValidationWorker) {
        self.networkService = networkService
        self.validator = validator
    }
}

// MARK: - UserServiceProtocol

extension UserService: UserServiceProtocol {

    func getUser(userId: UUID) async -> Result<User, Error> {
        let result = await networkService.getAllUsers()

        switch result {
        case .success(let dtos):
            guard let dto = dtos.first(where: { $0.id == userId }) else {
                return .failure(UserServiceError.userNotFound(userId: userId))
            }
            return .success(dto.toDomain())
        case .failure(let error):
            return .failure(error)
        }
    }

    func updateUser(
        userId: UUID,
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        phone: String?,
        dataImage: Data?
    ) async -> Result<User, Error> {
        if case .failure(let error) = validator.validateFirstName(firstName) { return .failure(error) }
        if case .failure(let error) = validator.validateLastName(lastName) { return .failure(error) }
        if case .failure(let error) = validator.validateEmail(email) { return .failure(error) }
        if case .failure(let error) = validator.validatePassword(password) { return .failure(error) }

        if let phone {
            if case .failure(let error) = validator.validatePhone(phone) { return .failure(error) }
        }

        let dto = UserDTO(
            id: userId,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            phone: phone,
            dataImage: dataImage?.base64EncodedString()
        )

        let result = await networkService.updateUser(dto)

        switch result {
        case .success:
            return .success(dto.toDomain())
        case .failure(let error):
            return .failure(error)
        }
    }
}

// MARK: - UserServiceError

extension UserService {
    enum UserServiceError: Error, LocalizedError {
        case userNotFound(userId: UUID)

        var errorDescription: String? {
            switch self {
            case .userNotFound(let userId): return "Пользователь с id \(userId.uuidString) не найден."
            }
        }
    }
}
