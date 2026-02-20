protocol AddCardPresenterInput: AnyObject {
    func presentSaveCardReult(response: AddCard.SaveCard.Response)
}

typealias AddCardPresenterOutput = AddCardViewControllerInput

final class AddCardPresenter {

    // MARK: Public properties

    weak var viewController: AddCardPresenterOutput?
}

// MARK: - AddCardInteractorInput

extension AddCardPresenter: AddCardPresenterInput {
    func presentSaveCardReult(response: AddCard.SaveCard.Response) {
        // code
    }
}
