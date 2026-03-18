protocol HomeInteractorInput: AnyObject {
    func loadData(request: Home.LoadData.Request)
}

typealias HomeInteractorOutput = HomePresenterInput

final class HomeInteractor {

    // MARK: Public properties

    var presenter: HomeInteractorOutput?

    // MARK: Private properties

    private let provider: HomeProviderProtocol
    private var loadTask: Task<Void, Never>?

    // MARK: Init

    init(provider: HomeProviderProtocol) {
        self.provider = provider
    }
}

// MARK: - HomeInteractorInput

extension HomeInteractor: HomeInteractorInput {
    func loadData(request: Home.LoadData.Request) {
        loadTask?.cancel()
        loadTask = Task {
            async let userResult = provider.loadUser(userId: request.userId)
            async let cardsResult = provider.loadCards(userId: request.userId)
            async let transactionsResult = provider.loadTransactions(userId: request.userId)

            let user = await userResult
            let cards = await cardsResult
            let transactions = await transactionsResult

            let response: Home.LoadData.Response

            guard !Task.isCancelled else { return }

            switch (user, cards, transactions) {
            case (.success(let user), .success(let cards), .success(let transactions)):
                response = .init(result: .success(.init(
                    user: user,
                    cards: cards,
                    transactions: transactions
                )))
            case (.failure(let error), _, _):
                response = .init(result: .failure(error))
            case (_, .failure(let error), _):
                response = .init(result: .failure(error))
            case (_, _, .failure(let error)):
                response = .init(result: .failure(error))
            }

            await MainActor.run {
                presenter?.presentData(response: response)
            }
        }
    }
}
