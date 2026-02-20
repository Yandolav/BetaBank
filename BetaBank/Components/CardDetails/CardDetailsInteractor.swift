protocol CardDetailsInteractorInput: AnyObject {
    func loadData(request: CardDetails.LoadData.Request)
}

typealias CardDetailsInteractorOutput = CardDetailsPresenterInput

final class CardDetailsInteractor {

    // MARK: Private properties

    private let provider: CardDetailsProviderProtocol

    // MARK: Public properties

    var presenter: CardDetailsInteractorOutput?

    // MARK: Init

    init(provider: CardDetailsProviderProtocol) {
        self.provider = provider
    }
}

// MARK: - CardDetailsInteractorInput

extension CardDetailsInteractor: CardDetailsInteractorInput {
    func loadData(request: CardDetails.LoadData.Request) {
        // code
    }
}
