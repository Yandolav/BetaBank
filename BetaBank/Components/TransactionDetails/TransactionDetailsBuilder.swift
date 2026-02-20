import Foundation

protocol TransactionDetailsBuilderProtocol {
    func build(dependencyContainer: DependencyContainer, transactionId: UUID) -> TransactionDetailsViewController
}

final class TransactionDetailsBuilder: TransactionDetailsBuilderProtocol {
    func build(dependencyContainer: DependencyContainer, transactionId: UUID) -> TransactionDetailsViewController {
        let provider = TransactionDetailsProvider(transactionService: dependencyContainer.getTransactionService())

        let viewController = TransactionDetailsViewController()
        let interactor = TransactionDetailsInteractor(provider: provider)
        let presenter = TransactionDetailsPresenter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

        return viewController
    }
}
