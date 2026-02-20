import UIKit

protocol TransferViewControllerInput: AnyObject {
    func displayCards(viewModel: Transfer.LoadCards.ViewModel)
    func displayTransferResult(viewModel: Transfer.Transfer.ViewModel)
    func showBackScreen()
}

typealias TransferViewControllerOutput = TransferInteractorInput

final class TransferViewController: UIViewController {

    // MARK: Public properties

    var interactor: TransferViewControllerOutput?
    weak var coordinator: Coordinator?

    // MARK: Lifecycle

    override func loadView() {
        let view = TransferView()
        view.delegate = self
        self.view = view
    }
}

// MARK: - TransferViewControllerInput

extension TransferViewController: TransferViewControllerInput {
    func displayCards(viewModel: Transfer.LoadCards.ViewModel) {
        // code
    }
    
    func displayTransferResult(viewModel: Transfer.Transfer.ViewModel) {
        // code
    }

    func showBackScreen() {
        // code
    }
}

// MARK: - TransferViewDelegate

extension TransferViewController: TransferViewDelegate {
    func transfer(
        amountMinor: Int,
        comment: String?,
        fromCard from: UUID,
        toCard to: UUID
    ) {
        // code
    }
}
