import Foundation

protocol AuthServiceProtocol {
    func signIn(email: String?, password: String?) async -> Result<UUID, Error>
    func signUp(firstName: String?, lastName: String?, email: String?, password: String?) async -> Result<UUID, Error>
    func firstNameTextFieldValidate(firstName: String?) -> Result<Void, Error>
    func lastNameTextFieldValidate(lastName: String?) -> Result<Void, Error>
    func emailTextFieldValidate(email: String?) -> Result<Void, Error>
    func passwordTextFieldValidate(password: String?) -> Result<Void, Error>
}

final class AuthService {

    // MARK: Private properties

    private let networkService: UserNetworkServiceProtocol
    private let validator: ValidationWorker

    // MARK: Init

    init(networkService: UserNetworkServiceProtocol, validator: ValidationWorker) {
        self.networkService = networkService
        self.validator = validator
    }
}

// MARK: - AuthServiceProtocol

extension AuthService: AuthServiceProtocol {

    func signIn(email: String?, password: String?) async -> Result<UUID, Error> {
        let result = await networkService.getAllUsers()

        switch result {
        case .success(let dtos):
            guard let user = dtos.first(where: { $0.email == email }) else {
                return .failure(AuthError.userNotFound)
            }
            guard user.password == password else {
                return .failure(AuthError.wrongPassword)
            }
            return .success(user.id)
        case .failure(let error):
            return .failure(error)
        }
    }

    func signUp(
        firstName: String?,
        lastName: String?,
        email: String?,
        password: String?
    ) async -> Result<UUID, Error> {
        if case .failure(let error) = validator.validateFirstName(firstName) { return .failure(error) }
        if case .failure(let error) = validator.validateLastName(lastName) { return .failure(error) }
        if case .failure(let error) = validator.validateEmail(email) { return .failure(error) }
        if case .failure(let error) = validator.validatePassword(password) { return .failure(error) }

        guard let firstName, let lastName, let email, let password else {
            return .failure(AuthError.failedToSaveUser)
        }

        let listResult = await networkService.getAllUsers()
        if case .success(let dtos) = listResult {
            guard !dtos.contains(where: { $0.email == email }) else {
                return .failure(AuthError.emailAlreadyInUse)
            }
        }

        let newUser = UserDTO(
            id: UUID(),
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            phone: nil,
            dataImage: nil
        )

        let result = await networkService.saveUser(newUser)

        switch result {
        case .success: return .success(newUser.id)
        case .failure(let error): return .failure(error)
        }
    }

    func firstNameTextFieldValidate(firstName: String?) -> Result<Void, Error> {
        validator.validateFirstName(firstName)
    }

    func lastNameTextFieldValidate(lastName: String?) -> Result<Void, Error> {
        validator.validateLastName(lastName)
    }

    func emailTextFieldValidate(email: String?) -> Result<Void, Error> {
        validator.validateEmail(email)
    }

    func passwordTextFieldValidate(password: String?) -> Result<Void, Error> {
        validator.validatePassword(password)
    }
}

// MARK: - AuthError

extension AuthService {
    enum AuthError: Error, LocalizedError {
        case userNotFound
        case wrongPassword
        case emailAlreadyInUse
        case failedToSaveUser

        var errorDescription: String? {
            switch self {
            case .userNotFound:
                return "Пользователя с такой почтой не существует."
            case .wrongPassword:
                return "Неверный пароль!"
            case .emailAlreadyInUse:
                return "Пользователь с такой почтой уже существует."
            case .failedToSaveUser:
                return "Не удалось сохранить данные пользователя."
            }
        }
    }
}
