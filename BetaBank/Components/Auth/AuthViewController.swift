import UIKit

protocol AuthViewControllerInput: AnyObject {
    func displaySignInResult(viewModel: Auth.SignIn.ViewModel)
    func displaySignUpResult(viewModel: Auth.SignUp.ViewModel)
    func displayFirstNameTextFieldValidate(viewModel: Auth.FirstNameValidate.ViewModel)
    func displayLastNameTextFieldValidate(viewModel: Auth.LastNameValidate.ViewModel)
    func displayEmailTextFieldValidate(viewModel: Auth.EmailValidate.ViewModel)
    func displayPasswordTextFieldValidate(viewModel: Auth.PasswordValidate.ViewModel)
    func showHomeScreen(userId: UUID)
}

typealias AuthViewControllerOutput = AuthInteractorInput

final class AuthViewController: UIViewController {

    // MARK: Public properties

    weak var coordinator: Coordinator?
    var interactor: AuthViewControllerOutput?

    // MARK: Private properties

    private var authView: AuthView? {
        get {
            view as? AuthView
        }
    }

    // MARK: Lifecycle

    override func loadView() {
        let view = AuthView()
        view.delegate = self
        self.view = view
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - AuthViewControllerInput

extension AuthViewController: AuthViewControllerInput {
    func displaySignInResult(viewModel: Auth.SignIn.ViewModel) {
        guard let authView = authView else { return }

        switch viewModel.state {
        case .content:
            break
        case .error(message: let error):
            authView.sumbitError(errorMessage: error)
        }
    }

    func displaySignUpResult(viewModel: Auth.SignUp.ViewModel) {
        guard let authView = authView else { return }

        switch viewModel.state {
        case .content:
            break
        case .error(message: let error):
            authView.sumbitError(errorMessage: error)
        }
    }

    func displayFirstNameTextFieldValidate(viewModel: Auth.FirstNameValidate.ViewModel) {
        guard let authView = authView else { return }

        switch viewModel.state {
        case .content:
            authView.validateFirstNameField(textFieldState: .success)
        case .error(message: let message):
            authView.validateFirstNameField(textFieldState: .error(errorMessage: message))
        }
    }

    func displayLastNameTextFieldValidate(viewModel: Auth.LastNameValidate.ViewModel) {
        guard let authView = authView else { return }

        switch viewModel.state {
        case .content:
            authView.validateLastNameField(textFieldState: .success)
        case .error(message: let message):
            authView.validateLastNameField(textFieldState: .error(errorMessage: message))
        }
    }

    func displayEmailTextFieldValidate(viewModel: Auth.EmailValidate.ViewModel) {
        guard let authView = authView else { return }

        switch viewModel.state {
        case .content:
            authView.validateEmailField(textFieldState: .success)
        case .error(message: let message):
            authView.validateEmailField(textFieldState: .error(errorMessage: message))
        }
    }

    func displayPasswordTextFieldValidate(viewModel: Auth.PasswordValidate.ViewModel) {
        guard let authView = authView else { return }

        switch viewModel.state {
        case .content:
            authView.validatePasswordField(textFieldState: .success)
        case .error(message: let message):
            authView.validatePasswordField(textFieldState: .error(errorMessage: message))
        }
    }

    func showHomeScreen(userId: UUID) {
        coordinator?.showHomeScreen(userId: userId)
    }
}

// MARK: - AuthViewDelegate

extension AuthViewController: AuthViewDelegate {
    func didTapSignIn(email: String?,password: String?) {
        interactor?.signIn(request: .init(password: password, email: email))
    }

    func didTapSignUp(firstName: String?, lastName: String?, email: String?, password: String?) {
        interactor?.signUp(request: .init(firstName: firstName, lastName: lastName, password: password, email: email))
    }

    func firstNameTextFieldValidate(text: String?) {
        interactor?.firstNameValidate(request: .init(firstName: text))
    }

    func lastNameTextFieldValidate(text: String?) {
        interactor?.lastNameValidate(request: .init(lastName: text))
    }

    func emailTextFieldValidate(text: String?) {
        interactor?.emailValidate(request: .init(email: text))
    }

    func passwordTextFieldValidate(text: String?) {
        interactor?.passwordValidate(request: .init(password: text))
    }
}
