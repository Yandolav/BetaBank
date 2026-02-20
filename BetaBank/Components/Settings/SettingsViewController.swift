import UIKit

protocol SettingsViewControllerInput: AnyObject {
    func displayLogoutResult(viewModel: Settings.Logout.ViewModel)
    func displayDeleteAccountResult(viewModel: Settings.DeleteAccount.ViewModel)
}

typealias SettingsViewControllerOutput = SettingsInteractorInput

final class SettingsViewController: UIViewController {

    // MARK: Public properties

    var interactor: SettingsViewControllerOutput?
    weak var coordinator: Coordinator?

    // MARK: Lifecycle

    override func loadView() {
        let view = SettingsView()
        view.delegate = self
        self.view = view
    }
}

// MARK: - SettingsViewControllerInput

extension SettingsViewController: SettingsViewControllerInput {
    func displayLogoutResult(viewModel: Settings.Logout.ViewModel) {
        // code
    }
    
    func displayDeleteAccountResult(viewModel: Settings.DeleteAccount.ViewModel) {
        //code
    }
}

// MARK: - SettingsViewDelegate

extension SettingsViewController: SettingsViewDelegate {
    func didTapOnDelete() {
        // code
    }
    
    func didTapOnLogout() {
        // code
    }
    
    func didTapOnEditProfile() {
        // code
    }
}
