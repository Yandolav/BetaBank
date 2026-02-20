protocol SettingsInteractorInput: AnyObject {
    func logout(request: Settings.Logout.Request)
    func deleteAccount(request: Settings.DeleteAccount.Request)
}

typealias SettingsInteractorOutput = SettingsPresenterInput

final class SettingsInteractor {

    // MARK: Private properties

    private let provider: SettingsProviderProtocol

    // MARK: Public properties

    var presenter: SettingsInteractorOutput?

    // MARK: Init

    init(provider: SettingsProviderProtocol) {
        self.provider = provider
    }
}

// MARK: - SettingsInteractorInput

extension SettingsInteractor: SettingsInteractorInput {
    func logout(request: Settings.Logout.Request) {
        // code
    }
    
    func deleteAccount(request: Settings.DeleteAccount.Request) {
        // code
    }
}
