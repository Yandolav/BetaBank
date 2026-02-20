protocol TransferPresenterInput: AnyObject {
    func presentCard(response: Transfer.LoadCards.Response)
    func presentTransferResult(response: Transfer.Transfer.Response)
}

typealias TransferPresenterOutput = TransferViewControllerInput

final class TransferPresenter {

    // MARK: Public properties

    weak var viewController: TransferPresenterOutput?
}

// MARK: - TransferInteractorInput

extension TransferPresenter: TransferPresenterInput {
    func presentCard(response: Transfer.LoadCards.Response) {
        // code
    }
    
    func presentTransferResult(response: Transfer.Transfer.Response) {
        // code
    }
}
