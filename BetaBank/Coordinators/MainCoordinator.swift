import Foundation
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

class MainCoordinator: Coordinator {

    // MARK: Private properties

    private let navigationController: UINavigationController
    private let dependencyContainer: DependencyContainer = DependencyContainer()

    // MARK: Init

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: Public properties

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
        // code
    }

    func showTransactionDetails(transactionId: UUID) {
        // code
    }

    func showSettingsScreen(userId: UUID) {
        // code
    }

    func showEditProfileScreen(userId: UUID) {
        // code
    }

    func showAddCardScreen(userId: UUID) {
        // code
    }

    func showTransferScreen(userId: UUID) {
        // code
    }
}
