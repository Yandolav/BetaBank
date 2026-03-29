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
    private let cardsManager = CardsListManager()
    private let transactionsManager = TransactionsListManager()

    private var homeView: HomeView {
        view as! HomeView
    }

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
        let homeView = HomeView()
        homeView.delegate = self
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupManagers()
        loadData()
    }

    // MARK: Private methods

    private func setupManagers() {
        cardsManager.delegate = self
        cardsManager.bind(to: homeView.cardsCollectionView)

        transactionsManager.delegate = self
        transactionsManager.bind(to: homeView.transactionsCollectionView)
    }

    private func loadData() {
        homeView.setState(.loading)
        interactor?.loadData(request: .init(userId: currentUserId))
    }
}

// MARK: - HomeViewControllerInput

extension HomeViewController: HomeViewControllerInput {
    func displayData(viewModel: Home.LoadData.ViewModel) {
        switch viewModel.state {
        case .loading:
            homeView.setState(.loading)
        case .empty:
            homeView.setState(.empty)
        case .content(let user, let cards, let transactions):
            homeView.configure(bankName: "\(user.firstName) \(user.lastName)")
            cardsManager.setItems(cards)
            transactionsManager.setItems(transactions)
            homeView.setState(viewModel.state)
        case .error(let message):
            homeView.setState(.error(message: message))
        }
    }
}

// MARK: - HomeViewDelegate

extension HomeViewController: HomeViewDelegate {
    func didTapProfile() {
        coordinator?.showSettingsScreen(userId: currentUserId)
    }

    func didTapSend() {
        coordinator?.showTransferScreen(userId: currentUserId)
    }

    func didTapAddCard() {
        coordinator?.showAddCardScreen(userId: currentUserId)
    }

    func didTapRetry() {
        loadData()
    }

    func didRefresh() {
        interactor?.loadData(request: .init(userId: currentUserId))
    }

    func didChangeSearch(query: String) {
        transactionsManager.filter(by: query)
    }
}

// MARK: - CardsListManagerDelegate

extension HomeViewController: CardsListManagerDelegate {
    func didSelectCard(_ cardId: UUID) {
        coordinator?.showCardDetails(cardId: cardId)
    }
}

// MARK: - TransactionsListManagerDelegate

extension HomeViewController: TransactionsListManagerDelegate {
    func didSelectTransaction(_ transactionId: UUID) {
        coordinator?.showTransactionDetails(transactionId: transactionId)
    }
}
