import Foundation

protocol AddCardBuilderProtocol {
    func build(dependencyContainer: DependencyContainer, userId: UUID) -> AddCardViewController
}

final class AddCardBuilder: AddCardBuilderProtocol {
    func build(dependencyContainer: DependencyContainer, userId: UUID) -> AddCardViewController {
        let provider = AddCardProvider(cardService: dependencyContainer.getCardService())

        let viewController = AddCardViewController()
        let interactor = AddCardInteractor(provider: provider)
        let presenter = AddCardPresenter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

        return viewController
    }
}
