protocol AuthInteractorInput: AnyObject {
    func signIn(request: Auth.SignIn.Request)
    func signUp(request: Auth.SignUp.Request)
}

typealias AuthInteractorOutput = AuthPresenterInput

final class AuthInteractor {

    // MARK: Public properties

    var presenter: AuthInteractorOutput?

    // MARK: Private properties

    private let provider: AuthProviderProtocol

    // MARK: Init

    init(provider: AuthProviderProtocol) {
        self.provider = provider
    }
}

// MARK: - AuthInteractorInput

extension AuthInteractor: AuthInteractorInput {
    func signIn(request: Auth.SignIn.Request) {
        // code
    }
    
    func signUp(request: Auth.SignUp.Request) {
        // code
    }
}
