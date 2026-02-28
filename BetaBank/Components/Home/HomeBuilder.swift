import Foundation

protocol HomeBuilderProtocol {
    func build(dependencyContainer: DependencyContainer, userId: UUID) -> HomeViewController
}

final class HomeBuilder: HomeBuilderProtocol {
    func build(dependencyContainer: DependencyContainer, userId: UUID) -> HomeViewController {
        let provider = HomeProvider(
            userService: dependencyContainer.getUserService(),
            cardService: dependencyContainer.getCardService(),
            transactionService: dependencyContainer.getTransactionService()
        )

        let viewController = HomeViewController(currentUserId: userId)
        let interactor = HomeInteractor(provider: provider)
        let presenter = HomePresenter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

        return viewController
    }
}
