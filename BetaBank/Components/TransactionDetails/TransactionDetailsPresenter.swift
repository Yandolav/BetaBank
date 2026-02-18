protocol TransactionDetailsPresenterInput: AnyObject {
    func presentData(response: TransactionDetails.LoadData.Response)
}

typealias TransactionDetailsPresenterOutput = TransactionDetailsViewControllerInput

final class TransactionDetailsPresenter {

    // MARK: Public properties

    weak var viewController: TransactionDetailsPresenterOutput?
}

// MARK: - TransactionDetailsInteractorInput

extension TransactionDetailsPresenter: TransactionDetailsPresenterInput {
    func presentData(response: TransactionDetails.LoadData.Response) {
        // code
    }
}
