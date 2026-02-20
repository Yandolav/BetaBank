import Foundation

protocol AuthProviderProtocol {
    func signIn(email: String, password: String) -> Result<UUID, Error>

    func signUp(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) -> Result<UUID, Error>
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
}
