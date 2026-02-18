protocol TransferInteractorInput: AnyObject {
    func loadCards(request: Transfer.LoadCards.Request)
    func transfer(request: Transfer.Transfer.Request)
}

typealias TransferInteractorOutput = TransferPresenterInput

final class TransferInteractor {

    // MARK: Private properties

    private let provider: TransferProviderProtocol

    // MARK: Public properties

    var presenter: TransferInteractorOutput?

    // MARK: Init

    init(provider: TransferProviderProtocol) {
        self.provider = provider
    }
}

// MARK: - TransferInteractorInput

extension TransferInteractor: TransferInteractorInput {
    func loadCards(request: Transfer.LoadCards.Request) {
        // code
    }
    
    func transfer(request: Transfer.Transfer.Request) {
        // code
    }
}
