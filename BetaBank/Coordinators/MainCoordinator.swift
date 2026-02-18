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

    private var navigationController: UINavigationController

    // MARK: Init

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: Public properties

    func start() {
        // code
    }

    func showHomeScreen(userId: UUID) {
        // code
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
