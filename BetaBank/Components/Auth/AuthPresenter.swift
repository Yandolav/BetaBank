protocol AuthPresenterInput: AnyObject {
    func presentSignInResult(response: Auth.SignIn.Response)
    func presentSignUpResult(response: Auth.SignUp.Response)
}

typealias AuthPresenterOutput = AuthViewControllerInput

final class AuthPresenter {

    // MARK: Public properties

    weak var viewController: AuthPresenterOutput?
}

// MARK: - AuthPresenterInput

extension AuthPresenter: AuthPresenterInput {
    func presentSignInResult(response: Auth.SignIn.Response) {
        // code
    }
    
    func presentSignUpResult(response: Auth.SignUp.Response) {
        // code
    }
}
