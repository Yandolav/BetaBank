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
    ) -> Result<User, Error>

    func getUser(userId: UUID) -> Result<User, Error>

    func deleteUser(userId: UUID) -> Result<Void, Error>
}

final class UserService {

    // MARK: Private properties

    private let userStorage: any UserStorageProtocol

    // MARK: Init

    init(userStorage: any UserStorageProtocol) {
        self.userStorage = userStorage
    }
}

// MARK: - UserServiceProtocol

extension UserService: UserServiceProtocol {
    func updateUser(
        userId: UUID,
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        phone: String?,
        dataImage: Data?
    ) -> Result<User, Error> {
        .failure(StorageError.existingEntity)
    }

    func getUser(userId: UUID) -> Result<User, Error> {
        .failure(StorageError.existingEntity)
    }

    func deleteUser(userId: UUID) -> Result<Void, Error> {
        .failure(StorageError.existingEntity)
    }
}

// MARK: - UserServiceError

extension UserService {
    enum UserServiceError: Error, LocalizedError {
        case userNotFound(userId: UUID)
        case userAlreadyExists(userId: UUID)
        case invalidFirstName
        case invalidLastName
        case invalidEmail
        case invalidPassword
        case invalidPhone
        case failedToLoad
        case failedToSave
        case failedToDelete
        case unknown(underlying: Error)

        var errorDescription: String? {
            switch self {
            case .userNotFound(let userId):
                return "Пользователь с id \(userId.uuidString) не найден."
            case .userAlreadyExists(let userId):
                return "Пользователь с id \(userId.uuidString) уже существует."
            case .invalidFirstName:
                return "Некорректное имя."
            case .invalidLastName:
                return "Некорректная фамилия."
            case .invalidEmail:
                return "Некорректный email."
            case .invalidPassword:
                return "Некорректный пароль."
            case .invalidPhone:
                return "Некорректный номер телефона."
            case .failedToLoad:
                return "Не удалось получить данные пользователя."
            case .failedToSave:
                return "Не удалось сохранить данные пользователя."
            case .failedToDelete:
                return "Не удалось удалить пользователя."
            case .unknown(let underlying):
                return "Неизвестная ошибка: \(underlying.localizedDescription)"
            }
        }
    }
}
