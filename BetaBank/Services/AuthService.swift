import Foundation

protocol AuthServiceProtocol {
    func signIn(email: String, password: String) -> Result<UUID, Error>

    func signUp(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) -> Result<UUID, Error>

    func logout(userId: UUID) -> Result<Void, Error>
}

class AuthService {

    // MARK: Private properties

    private let storage: any UserStorageProtocol

    // MARK: Init

    init(storage: any UserStorageProtocol) {
        self.storage = storage
    }
}

// MARK: - AuthServiceProtocol

extension AuthService: AuthServiceProtocol {
    func signIn(email: String, password: String) -> Result<UUID, Error> {
        .success(UUID())
    }

    func signUp(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) -> Result<UUID, Error> {
        .success(UUID())
    }

    func logout(userId: UUID) -> Result<Void, Error> {
        .success(())
    }
}

// MARK: - AuthError

extension AuthService {
    enum AuthError: Error, LocalizedError {
        case emptyEmail
        case emptyPassword
        case emptyFirstName
        case emptyLastName
        case invalidEmail
        case invalidPassword
        case invalidFirstName
        case invalidLastName
        case userNotFound
        case wrongCredentials
        case emailAlreadyInUse
        case sessionNotFound(userId: UUID)
        case failedToLoadUsers
        case failedToSaveUser
        case failedToDeleteSession
        case unknown(underlying: Error)

        var errorDescription: String? {
            switch self {
            case .emptyEmail:
                return "Email не может быть пустым."
            case .emptyPassword:
                return "Пароль не может быть пустым."
            case .emptyFirstName:
                return "Имя не может быть пустым."
            case .emptyLastName:
                return "Фамилия не может быть пустой."
            case .invalidEmail:
                return "Некорректный email."
            case .invalidPassword:
                return "Некорректный пароль."
            case .invalidFirstName:
                return "Некорректное имя."
            case .invalidLastName:
                return "Некорректная фамилия."
            case .userNotFound:
                return "Пользователь с таким email не найден."
            case .wrongCredentials:
                return "Неверный email или пароль."
            case .emailAlreadyInUse:
                return "Пользователь с такой почтой уже существует."
            case .sessionNotFound(let userId):
                return "Сессия пользователя \(userId.uuidString) не найдена."
            case .failedToLoadUsers:
                return "Не удалось получить данные пользователей."
            case .failedToSaveUser:
                return "Не удалось сохранить данные пользователя."
            case .failedToDeleteSession:
                return "Не удалось завершить сессию пользователя."
            case .unknown(let underlying):
                return "Неизвестная ошибка: \(underlying.localizedDescription)"
            }
        }
    }
}
