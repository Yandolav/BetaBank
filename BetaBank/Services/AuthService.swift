import Foundation

protocol AuthServiceProtocol {
    func signIn(email: String, password: String) -> Result<UUID, Error>

    func signUp(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) -> Result<UUID, Error>

    func firstNameTextFieldValidate(firstName: String) -> Result<Void, Error>
    func lastNameTextFieldValidate(lastName: String) -> Result<Void, Error>
    func emailTextFieldValidate(email: String) -> Result<Void, Error>
    func passwordTextFieldValidate(password: String) -> Result<Void, Error>
}

class AuthService {

    // MARK: Private properties

    private let storage: any UserStorageProtocol

    // MARK: Init

    init(storage: any UserStorageProtocol) {
        self.storage = storage
    }

    // MARK: Private methods

    private func validateName(
        _ value: String,
        emptyError: AuthError,
        invalidError: AuthError
    ) -> Result<Void, Error> {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else { return .failure(emptyError) }
        guard trimmed.allSatisfy({$0.isLetter}) else { return .failure(invalidError) }

        return .success(())
    }

    private func validateEmail(_ value: String) -> Result<Void, Error> {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .failure(AuthError.emptyEmail) }

        let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+\.[A-Za-z]{2,}$"#
        let isValid = trimmed.range(of: pattern, options: .regularExpression) != nil
        guard isValid else { return .failure(AuthError.invalidEmail)}

        return .success(())
    }

    private func validatePassword(_ value: String) -> Result<Void, Error> {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .failure(AuthError.emptyPassword) }

        var hasCapitalLetter = false
        var hasNumber = false
        var hasSpecialCharacter = false
        for character in trimmed {
            if hasCapitalLetter, hasNumber, hasSpecialCharacter { break }

            if character.isLetter, character.isUppercase {
                hasCapitalLetter = true
            } else if character.isNumber {
                hasNumber = true
            } else if character == "!" || character == "@" || character == "?" || character == "." {
                hasSpecialCharacter = true
            } else if character.isWhitespace {
                return .failure(AuthError.invalidPassword)
            }
        }
        guard hasCapitalLetter, hasNumber, hasSpecialCharacter else { return .failure(AuthError.invalidPassword) }

        return .success(())
    }
}

// MARK: - AuthServiceProtocol

extension AuthService: AuthServiceProtocol {
    func signIn(email: String, password: String) -> Result<UUID, Error> {
        let allUsers = storage.fetchAll()
        guard let user = allUsers.first(where: {$0.email == email}) else {
            return .failure(AuthError.userNotFound)
        }

        guard user.password == password else {
            return .failure(AuthError.wrongPassword)
        }

        return .success(user.id)
    }

    func signUp(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) -> Result<UUID, Error> {
        let allUsers = storage.fetchAll()
        guard !allUsers.contains(where: {$0.email == email}) else {
            return .failure(AuthError.emailAlreadyInUse)
        }

        let user = User(
            id: UUID(),
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            phone: nil,
            dataImage: nil
        )
        switch storage.create(entity: user) {
        case .success():
            return .success(user.id)
        case .failure(let error):
            print(error)
            return .failure(AuthError.failedToSaveUser)
        }
    }

    func firstNameTextFieldValidate(firstName: String) -> Result<Void, Error> {
        validateName(firstName, emptyError: AuthError.emptyFirstName, invalidError: AuthError.invalidFirstName)
    }

    func lastNameTextFieldValidate(lastName: String) -> Result<Void, Error> {
        validateName(lastName, emptyError: AuthError.emptyLastName, invalidError: AuthError.invalidLastName)
    }

    func emailTextFieldValidate(email: String) -> Result<Void, Error> {
        validateEmail(email)
    }

    func passwordTextFieldValidate(password: String) -> Result<Void, Error> {
        validatePassword(password)
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
        case wrongPassword
        case emailAlreadyInUse
        case failedToSaveUser

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
                return "Некорректная почта."
            case .invalidPassword:
                return "Некорректный пароль. Пароль должен не содержать пробелов и содержать как минимум 1 цифру, заглавную букву и спецсимвол из списка: !@?."
            case .invalidFirstName:
                return "Некорректное имя."
            case .invalidLastName:
                return "Некорректная фамилия."
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
