import Foundation

protocol AuthPresenterInput: AnyObject {
    func presentSignInResult(response: Auth.SignIn.Response)
    func presentSignUpResult(response: Auth.SignUp.Response)
    func presentFirstNameValidate(response: Auth.FirstNameValidate.Response)
    func presentLastNameValidate(response: Auth.LastNameValidate.Response)
    func presentEmailValidate(response: Auth.EmailValidate.Response)
    func presentPasswordValidate(response: Auth.PasswordValidate.Response)
}

typealias AuthPresenterOutput = AuthViewControllerInput

final class AuthPresenter {

    // MARK: Public properties

    weak var viewController: AuthPresenterOutput?

    // MARK: Private properties

    private func authHandle(result: Result<UUID, Error>) {
        switch result {
        case .success(let userId):
            viewController?.showHomeScreen(userId: userId)
        case .failure(let error):
            viewController?.displaySignInResult(viewModel: .init(state: .error(message: error.localizedDescription)))
        }
    }
}

// MARK: - AuthPresenterInput

extension AuthPresenter: AuthPresenterInput {
    func presentSignInResult(response: Auth.SignIn.Response) {
        self.authHandle(result: response.result)
    }

    func presentSignUpResult(response: Auth.SignUp.Response) {
        self.authHandle(result: response.result)
    }

    func presentFirstNameValidate(response: Auth.FirstNameValidate.Response) {
        switch response.result {
        case .success(()):
            viewController?.displayFirstNameTextFieldValidate(viewModel: .init(state: .content))
        case .failure(let error):
            viewController?.displayFirstNameTextFieldValidate(viewModel: .init(state: .error(message: error.localizedDescription)))
        }
    }

    func presentLastNameValidate(response: Auth.LastNameValidate.Response) {
        switch response.result {
        case .success(()):
            viewController?.displayLastNameTextFieldValidate(viewModel: .init(state: .content))
        case .failure(let error):
            viewController?.displayLastNameTextFieldValidate(viewModel: .init(state: .error(message: error.localizedDescription)))
        }
    }

    func presentEmailValidate(response: Auth.EmailValidate.Response) {
        switch response.result {
        case .success(()):
            viewController?.displayEmailTextFieldValidate(viewModel: .init(state: .content))
        case .failure(let error):
            viewController?.displayEmailTextFieldValidate(viewModel: .init(state: .error(message: error.localizedDescription)))
        }
    }

    func presentPasswordValidate(response: Auth.PasswordValidate.Response) {
        switch response.result {
        case .success(()):
            viewController?.displayPasswordTextFieldValidate(viewModel: .init(state: .content))
        case .failure(let error):
            viewController?.displayPasswordTextFieldValidate(viewModel: .init(state: .error(message: error.localizedDescription)))
        }
    }
}
