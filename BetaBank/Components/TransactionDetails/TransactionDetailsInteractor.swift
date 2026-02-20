protocol TransactionDetailsInteractorInput: AnyObject {
    func loadData(request: TransactionDetails.LoadData.Request)
}

typealias TransactionDetailsInteractorOutput = TransactionDetailsPresenterInput

final class TransactionDetailsInteractor {

    // MARK: Private properties

    private let provider: TransactionDetailsProviderProtocol

    // MARK: Public properties

    var presenter: TransactionDetailsInteractorOutput?

    // MARK: Init

    init(provider: TransactionDetailsProviderProtocol) {
        self.provider = provider
    }
}

// MARK: - TransactionDetailsInteractorInput

extension TransactionDetailsInteractor: TransactionDetailsInteractorInput {
    func loadData(request: TransactionDetails.LoadData.Request) {
        // code
    }
}

