import UIKit

protocol AddCardViewControllerInput: AnyObject {
    func displaySaveCardResult(viewModel: AddCard.SaveCard.ViewModel)
    func showBackScreen()
}

typealias AddCardViewControllerOutput = AddCardInteractorInput

final class AddCardViewController: UIViewController {

    // MARK: Public properties

    var interactor: AddCardViewControllerOutput?
    weak var coordinator: Coordinator?

    // MARK: Lifecycle

    override func loadView() {
        let view = AddCardView()
        view.delegate = self
        self.view = view
    }
}

// MARK: - AddCardViewControllerInput

extension AddCardViewController: AddCardViewControllerInput {
    func displaySaveCardResult(viewModel: AddCard.SaveCard.ViewModel) {
        // code
    }

    func showBackScreen() {
        // code
    }
}

// MARK: - AddCardViewDelegate

extension AddCardViewController: AddCardViewDelegate {
    func didTapOnSave(userFullName: String, bankName: String) {
        // code
    }
}
