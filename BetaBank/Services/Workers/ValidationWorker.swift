import Foundation

final class ValidationWorker {

    func validateFirstName(_ value: String) -> Result<Void, Error> {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .failure(ValidationError.invalidFirstName) }
        guard trimmed.allSatisfy({ $0.isLetter }) else { return .failure(ValidationError.invalidFirstName) }
        return .success(())
    }

    func validateLastName(_ value: String) -> Result<Void, Error> {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .failure(ValidationError.invalidLastName) }
        guard trimmed.allSatisfy({ $0.isLetter }) else { return .failure(ValidationError.invalidLastName) }
        return .success(())
    }

    func validateEmail(_ value: String) -> Result<Void, Error> {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .failure(ValidationError.invalidEmail) }
        let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+\.[A-Za-z]{2,}$"#
        let isValid = trimmed.range(of: pattern, options: .regularExpression) != nil
        guard isValid else { return .failure(ValidationError.invalidEmail) }
        return .success(())
    }

    func validatePassword(_ value: String) -> Result<Void, Error> {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .failure(ValidationError.invalidPassword) }

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
                return .failure(ValidationError.invalidPassword)
            }
        }
        guard hasCapitalLetter, hasNumber, hasSpecialCharacter else { return .failure(ValidationError.invalidPassword) }
        return .success(())
    }

    func validatePhone(_ value: String) -> Result<Void, Error> {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .failure(ValidationError.invalidPhone) }
        let pattern = #"^\+?[0-9]{10,15}$"#
        let isValid = trimmed.range(of: pattern, options: .regularExpression) != nil
        guard isValid else { return .failure(ValidationError.invalidPhone) }
        return .success(())
    }
}

// MARK: - ValidationError

extension ValidationWorker {
    enum ValidationError: Error, LocalizedError {
        case invalidFirstName
        case invalidLastName
        case invalidEmail
        case invalidPassword
        case invalidPhone

        var errorDescription: String? {
            switch self {
            case .invalidFirstName: return "Некорректное имя."
            case .invalidLastName: return "Некорректная фамилия."
            case .invalidEmail: return "Некорректный email."
            case .invalidPassword: return "Некорректный пароль. Пароль должен не содержать пробелов и содержать как минимум 1 цифру, заглавную букву и спецсимвол из списка: !@?."
            case .invalidPhone: return "Некорректный номер телефона."
            }
        }
    }
}
