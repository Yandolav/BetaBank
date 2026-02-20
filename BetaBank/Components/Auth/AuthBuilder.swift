protocol AuthBuilderProtocol {
    func build(dependencyContainer: DependencyContainer) -> AuthViewController
}

final class AuthBuilder: AuthBuilderProtocol {
    func build(dependencyContainer: DependencyContainer) -> AuthViewController {
        let provider = AuthProvider(authService: dependencyContainer.getAuthService())

        let viewController = AuthViewController()
        let presenter = AuthPresenter()
        let interactor = AuthInteractor(provider: provider)

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

        return viewController
    }
}
