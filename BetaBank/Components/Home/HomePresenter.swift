protocol HomePresenterInput: AnyObject {
    func presentData(response: Home.LoadData.Response)
}

typealias HomePresenterOutput = HomeViewControllerInput

final class HomePresenter {

    // MARK: Public properties

    weak var viewController: HomePresenterOutput?
}

// MARK: - HomePresenterInput

extension HomePresenter: HomePresenterInput {
    func presentData(response: Home.LoadData.Response) {
        // code
    }
}
