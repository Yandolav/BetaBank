import UIKit

protocol AuthViewControllerInput: AnyObject {
    func displaySignInResult(viewModel: Auth.SignIn.ViewModel)
    func displaySignUpResult(viewModel: Auth.SignUp.ViewModel)
    func showHomeScreen(userId: UUID)
}

typealias AuthViewControllerOutput = AuthInteractorInput

final class AuthViewController: UIViewController {

    // MARK: Public properties

    weak var coordinator: Coordinator?
    var interactor: AuthViewControllerOutput?

    // MARK: Lifecycle

    override func loadView() {
        let view = AuthView()
        view.delegate = self
        self.view = view
    }
}

// MARK: - AuthViewControllerInput

extension AuthViewController: AuthViewControllerInput {
    func displaySignInResult(viewModel: Auth.SignIn.ViewModel) {
        // code
    }
    
    func displaySignUpResult(viewModel: Auth.SignUp.ViewModel) {
        // code
    }

    func showHomeScreen(userId: UUID) {
        // code
    }
}

// MARK: - AuthViewDelegate

extension AuthViewController: AuthViewDelegate {
    func didTapSignIn(email: String, password: String) {
        // code
    }
    
    func didTapSignUp(firstName: String, lastName: String, email: String, password: String) {
        // code
    }
}
