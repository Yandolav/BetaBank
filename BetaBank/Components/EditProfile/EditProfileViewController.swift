import UIKit

protocol EditProfileViewControllerInput: AnyObject {
    func displayUser(viewModel: EditProfile.LoadData.ViewModel)
    func displayStartEdit(viewModel: EditProfile.StartEditProfile.ViewModel)
    func displayNewUser(viewModel: EditProfile.SaveNewData.ViewModel)
    func showBackScreen()
}

typealias EditProfileViewControllerOutput = EditProfileInteractorInput

final class EditProfileViewController: UIViewController {

    // MARK: Public properties

    var interactor: EditProfileViewControllerOutput?
    weak var coordinator: Coordinator?

    // MARK: Lifecycle

    override func loadView() {
        let view = EditProfileView()
        view.delegate = self
        self.view = view
    }
}

// MARK: - EditProfileViewControllerInput

extension EditProfileViewController: EditProfileViewControllerInput {
    func displayUser(viewModel: EditProfile.LoadData.ViewModel) {
        // code
    }
    
    func displayStartEdit(viewModel: EditProfile.StartEditProfile.ViewModel) {
        // code
    }
    
    func displayNewUser(viewModel: EditProfile.SaveNewData.ViewModel) {
        // code
    }

    func showBackScreen() {
        // code
    }
}

// MARK: - EditProfileViewDelegate

extension EditProfileViewController: EditProfileViewDelegate {
    func didTapOnChange() {
        // code
    }
    
    func didTapOnSave(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        phone: String?,
        dataImage: Data?
    ) {
        // code
    }
}

