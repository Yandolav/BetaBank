import Foundation

protocol SettingsProviderProtocol: AnyObject {
    func deleteUser(userId: UUID) -> Result<Void, Error>
    func logout(userId: UUID) -> Result<Void, Error>
}

final class SettingsProvider {

    // MARK: Private properties

    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol

    // MARK: Init

    init(authService: AuthServiceProtocol, userService: UserServiceProtocol) {
        self.authService = authService
        self.userService = userService
    }
}

// MARK: - SettingsProviderProtocol

extension SettingsProvider: SettingsProviderProtocol {
    func deleteUser(userId: UUID) -> Result<Void, Error> {
        .success(())
    }
    
    func logout(userId: UUID) -> Result<Void, Error> {
        .success(())
    }
}
