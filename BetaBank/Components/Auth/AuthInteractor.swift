protocol AuthInteractorInput: AnyObject {
    func signIn(request: Auth.SignIn.Request)
    func signUp(request: Auth.SignUp.Request)
    func firstNameValidate(request: Auth.FirstNameValidate.Request)
    func lastNameValidate(request: Auth.LastNameValidate.Request)
    func emailValidate(request: Auth.EmailValidate.Request)
    func passwordValidate(request: Auth.PasswordValidate.Request)
}

typealias AuthInteractorOutput = AuthPresenterInput

final class AuthInteractor {

    // MARK: Public properties

    var presenter: AuthInteractorOutput?

    // MARK: Private properties

    private let provider: AuthProviderProtocol
    private var loadTask: Task<Void, Never>?

    // MARK: Init

    init(provider: AuthProviderProtocol) {
        self.provider = provider
    }
}

// MARK: - AuthInteractorInput

extension AuthInteractor: AuthInteractorInput {
    func signIn(request: Auth.SignIn.Request) {
        loadTask?.cancel()
        loadTask = Task {
            let result = await provider.signIn(email: request.email, password: request.password)

            guard !Task.isCancelled else { return }

            await MainActor.run {
                presenter?.presentSignInResult(response: .init(result: result))
            }
        }
    }

    func signUp(request: Auth.SignUp.Request) {
        loadTask?.cancel()
        loadTask = Task {
            let result = await provider.signUp(
                firstName: request.firstName,
                lastName: request.lastName,
                email: request.email,
                password: request.password
            )

            guard !Task.isCancelled else { return }

            await MainActor.run {
                presenter?.presentSignUpResult(response: .init(result: result))
            }
        }
    }

    func firstNameValidate(request: Auth.FirstNameValidate.Request) {
        let result = provider.firstNameValidate(firstName: request.firstName)
        presenter?.presentFirstNameValidate(response: .init(result: result))
    }

    func lastNameValidate(request: Auth.LastNameValidate.Request) {
        let result = provider.lastNameValidate(lastName: request.lastName)
        presenter?.presentLastNameValidate(response: .init(result: result))
    }

    func emailValidate(request: Auth.EmailValidate.Request) {
        let result = provider.emailValidate(email: request.email)
        presenter?.presentEmailValidate(response: .init(result: result))
    }

    func passwordValidate(request: Auth.PasswordValidate.Request) {
        let result = provider.passwordValidate(password: request.password)
        presenter?.presentPasswordValidate(response: .init(result: result))
    }
}
