protocol CardDetailsPresenterInput: AnyObject {
    func presentData(response: CardDetails.LoadData.Response)
}

typealias CardDetailsPresenterOutput = CardDetailsViewControllerInput

final class CardDetailsPresenter {

    // MARK: Public properties

    weak var viewController: CardDetailsPresenterOutput?
}

// MARK: - CardDetailsInteractorInput

extension CardDetailsPresenter: CardDetailsPresenterInput {
    func presentData(response: CardDetails.LoadData.Response) {
        // code
    }
}
