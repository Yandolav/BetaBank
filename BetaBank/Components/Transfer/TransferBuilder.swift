import Foundation

protocol TransferBuilderProtocol {
    func build(dependencyContainer: DependencyContainer, userId: UUID) -> TransferViewController
}

final class TransferBuilder: TransferBuilderProtocol {
    func build(dependencyContainer: DependencyContainer, userId: UUID) -> TransferViewController {
        let provider = TransferProvider(
            transactionService: dependencyContainer.getTransactionService(),
            cardService: dependencyContainer.getCardService()
        )

        let viewController = TransferViewController()
        let interactor = TransferInteractor(provider: provider)
        let presenter = TransferPresenter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

        return viewController
    }
}
