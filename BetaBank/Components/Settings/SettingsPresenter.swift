protocol SettingsPresenterInput: AnyObject {
    func presentLogoutResult(response: Settings.Logout.Response)
    func presentDeleteAccountResult(response: Settings.DeleteAccount.Response)
}

typealias SettingsPresenterOutput = SettingsViewControllerInput

final class SettingsPresenter {

    // MARK: Public properties

    weak var viewController: SettingsPresenterOutput?
}

// MARK: - SettingsInteractorInput

extension SettingsPresenter: SettingsPresenterInput {
    func presentLogoutResult(response: Settings.Logout.Response) {
        // code
    }
    
    func presentDeleteAccountResult(response: Settings.DeleteAccount.Response) {
        // code
    }
}
