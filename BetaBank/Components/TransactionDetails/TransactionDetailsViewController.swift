import UIKit

protocol TransactionDetailsViewControllerInput: AnyObject {
    func displayData(viewModel: TransactionDetails.LoadData.ViewModel)
}

typealias TransactionDetailsViewControllerOutput = TransactionDetailsInteractorInput

final class TransactionDetailsViewController: UIViewController {

    // MARK: Public properties

    var interactor: TransactionDetailsViewControllerOutput?
    weak var coordinator: Coordinator?

    // MARK: Lifecycle

    override func loadView() {
        self.view = TransactionDetailsView()
    }
}

// MARK: - TransactionDetailsViewControllerInput

extension TransactionDetailsViewController: TransactionDetailsViewControllerInput {
    func displayData(viewModel: TransactionDetails.LoadData.ViewModel) {
        // code
    }
}

