import UIKit

protocol HomeViewControllerInput: AnyObject {
    func displayData(viewModel: Home.LoadData.ViewModel)
}

typealias HomeViewControllerOutput = HomeInteractorInput

final class HomeViewController: UIViewController {

    // MARK: Public properties

    weak var coordinator: Coordinator?
    var interactor: HomeViewControllerOutput?

    // MARK: Private properties

    private let currentUserId: UUID

    // MARK: Init

    init(currentUserId: UUID) {
        self.currentUserId = currentUserId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func loadView() {
        let view = HomeView()
        view.delegate = self
        view.configure(id: currentUserId)
        self.view = view
    }
}

// MARK: - HomeViewControllerInput

extension HomeViewController: HomeViewControllerInput {
    func displayData(viewModel: Home.LoadData.ViewModel) {
        // code
    }
}

// MARK: - HomeViewDelegate

extension HomeViewController: HomeViewDelegate {
    func didTapOnProfile() {
        // code
    }

    func didSelectCard(_ cardId: UUID) {
        // code
    }

    func didSelectTransaction(_ transactionId: UUID) {
        // code
    }

    func didTapTransfer(fromCardId: UUID) {
        // code
    }

    func didTapOnAddScreen() {
        // code
    }
}
