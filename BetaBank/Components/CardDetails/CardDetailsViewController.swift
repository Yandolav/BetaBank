import UIKit

protocol CardDetailsViewControllerInput: AnyObject {
    func displayData(viewModel: CardDetails.LoadData.ViewModel)
}

typealias CardDetailsViewControllerOutput = CardDetailsInteractorInput

final class CardDetailsViewController: UIViewController {

    // MARK: Public properties

    var interactor: CardDetailsViewControllerOutput?

    // MARK: Lifecycle

    override func loadView() {
        self.view = CardDetailsView()
    }
}

// MARK: - CardDetailsViewControllerInput

extension CardDetailsViewController: CardDetailsViewControllerInput {
    func displayData(viewModel: CardDetails.LoadData.ViewModel) {
        // code
    }
}
