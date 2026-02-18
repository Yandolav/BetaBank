import Foundation

protocol SettingsBuilderProtocol {
    func build(dependencyContainer: DependencyContainer, userId: UUID) -> SettingsViewController
}

final class SettingsBuilder: SettingsBuilderProtocol {
    func build(dependencyContainer: DependencyContainer, userId: UUID) -> SettingsViewController {
        let provider = SettingsProvider(
            authService: dependencyContainer.getAuthService(),
            userService: dependencyContainer.getUserService()
        )

        let viewController = SettingsViewController()
        let interactor = SettingsInteractor(provider: provider)
        let presenter = SettingsPresenter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

        return viewController
    }
}
