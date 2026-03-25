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
        interactor?.loadData(request: .init(userId: currentUserId))
        self.view = view
    }
}

// MARK: - HomeViewControllerInput

extension HomeViewController: HomeViewControllerInput {
    func displayData(viewModel: Home.LoadData.ViewModel) {
        switch viewModel.state {
        case .empty:
            print("Empty")
        case .loading:
            print("Loading")
        case .content(user: let user, cards: let cards, transactions: let transactions):
            print("User: \(user)")
            print("----------")
            print("User cards: \(cards)")
            print("----------")
            print("User transactions: \(transactions)")
        case .error(message: let message):
            print("Error: \(message)")
        }
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
