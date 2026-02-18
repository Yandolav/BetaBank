import Foundation

protocol CardDetailsBuilderProtocol {
    func build(dependencyContainer: DependencyContainer, cardId: UUID) -> CardDetailsViewController
}

final class CardDetailsBuilder: CardDetailsBuilderProtocol {
    func build(dependencyContainer: DependencyContainer, cardId: UUID) -> CardDetailsViewController {
        let provider = CardDetailsProvider(cardService: dependencyContainer.getCardService())

        let viewController = CardDetailsViewController()
        let interactor = CardDetailsInteractor(provider: provider)
        let presenter = CardDetailsPresenter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

        return viewController
    }
}
