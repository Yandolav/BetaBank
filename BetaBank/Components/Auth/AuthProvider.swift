import Foundation

protocol AuthProviderProtocol {
    func signIn(email: String, password: String) async -> Result<UUID, Error>
    func signUp(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) async -> Result<UUID, Error>
    func firstNameValidate(firstName: String) -> Result<Void, Error>
    func lastNameValidate(lastName: String) -> Result<Void, Error>
    func emailValidate(email: String) -> Result<Void, Error>
    func passwordValidate(password: String) -> Result<Void, Error>
}

final class AuthProvider {

    // MARK: Private properties

    private let authService: AuthServiceProtocol

    // MARK: Init

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
}

// MARK: - AuthProviderProtocol

extension AuthProvider: AuthProviderProtocol {

    func signIn(email: String, password: String) async -> Result<UUID, Error> {
        await authService.signIn(email: email, password: password)
    }

    func signUp(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) async -> Result<UUID, Error> {
        await authService.signUp(firstName: firstName, lastName: lastName, email: email, password: password)
    }

    func firstNameValidate(firstName: String) -> Result<Void, Error> {
        authService.firstNameTextFieldValidate(firstName: firstName)
    }

    func lastNameValidate(lastName: String) -> Result<Void, Error> {
        authService.lastNameTextFieldValidate(lastName: lastName)
    }

    func emailValidate(email: String) -> Result<Void, Error> {
        authService.emailTextFieldValidate(email: email)
    }

    func passwordValidate(password: String) -> Result<Void, Error> {
        authService.passwordTextFieldValidate(password: password)
    }
}
