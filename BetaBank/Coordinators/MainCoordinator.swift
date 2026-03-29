import UIKit

protocol Coordinator: AnyObject {
    func start()
    func showHomeScreen(userId: UUID)
    func showCardDetails(cardId: UUID)
    func showTransactionDetails(transactionId: UUID)
    func showSettingsScreen(userId: UUID)
    func showEditProfileScreen(userId: UUID)
    func showAddCardScreen(userId: UUID)
    func showTransferScreen(userId: UUID)
}

final class MainCoordinator: Coordinator {

    // MARK: Private properties

    private let navigationController: UINavigationController
    private let dependencyContainer: DependencyContainer = DependencyContainer()

    // MARK: Init

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: Public methods

    func start() {
        let viewController = AuthBuilder().build(dependencyContainer: dependencyContainer)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    func showHomeScreen(userId: UUID) {
        let viewController = HomeBuilder().build(dependencyContainer: dependencyContainer, userId: userId)
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: true)
    }

    func showCardDetails(cardId: UUID) {
        let viewController = CardDetailsViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    func showTransactionDetails(transactionId: UUID) {
        let viewController = TransactionDetailsViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    func showSettingsScreen(userId: UUID) {
        let viewController = SettingsViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    func showEditProfileScreen(userId: UUID) {
        let viewController = EditProfileViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    func showAddCardScreen(userId: UUID) {
        let viewController = AddCardViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    func showTransferScreen(userId: UUID) {
        let viewController = TransferViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

