protocol HomeInteractorInput: AnyObject {
    func loadData(request: Home.LoadData.Request)
}

typealias HomeInteractorOutput = HomePresenterInput

final class HomeInteractor {

    // MARK: Public properties

    var presenter: HomeInteractorOutput?

    // MARK: Private properties

    let provider: HomeProviderProtocol

    // MARK: Init

    init(provider: HomeProviderProtocol) {
        self.provider = provider
    }
}

// MARK: - HomeInteractorInput

extension HomeInteractor: HomeInteractorInput {
    func loadData(request: Home.LoadData.Request) {
        // code
    }
}
