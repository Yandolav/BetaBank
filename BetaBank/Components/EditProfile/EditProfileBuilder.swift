import Foundation

protocol EditProfileBuilderProtocol {
    func build(dependencyContainer: DependencyContainer, userId: UUID) -> EditProfileViewController
}

final class EditProfileBuilder: EditProfileBuilderProtocol {
    func build(dependencyContainer: DependencyContainer, userId: UUID) -> EditProfileViewController {
        let provider = EditProfileProvider(userService: dependencyContainer.getUserService())

        let viewController = EditProfileViewController()
        let interactor = EditProfileInteractor(provider: provider)
        let presenter = EditProfilePresenter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

        return viewController
    }
}

