import UIKit

protocol HomeViewControllerInput: AnyObject {
    func displayData(viewModel: Home.LoadData.ViewModel)
}

typealias HomeViewControllerOutput = HomeInteractorInput

final class HomeViewController: UIViewController {

    // MARK: Public properties

    weak var coordinator: Coordinator?
    var interactor: HomeViewControllerOutput?

    // MARK: Lifecycle

    override func loadView() {
        let view = HomeView()
        view.delegate = self
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
