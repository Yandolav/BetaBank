protocol AddCardInteractorInput: AnyObject {
    func saveCard(request: AddCard.SaveCard.Request)
}

typealias AddCardInteractorOutput = AddCardPresenterInput

final class AddCardInteractor {

    // MARK: Private properties

    private let provider: AddCardProviderProtocol

    // MARK: Public properties

    var presenter: AddCardInteractorOutput?

    // MARK: Init

    init(provider: AddCardProviderProtocol) {
        self.provider = provider
    }
}

// MARK: - AddCardInteractorInput

extension AddCardInteractor: AddCardInteractorInput {
    func saveCard(request: AddCard.SaveCard.Request) {
        // code
    }
}
