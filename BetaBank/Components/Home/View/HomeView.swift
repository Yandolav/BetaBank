import UIKit

protocol HomeViewDelegate: AnyObject {
    func didTapOnProfile()
    func didSelectCard(_ cardId: UUID)
    func didSelectTransaction(_ transactionId: UUID)
    func didTapTransfer(fromCardId: UUID)
    func didTapOnAddScreen()
}

final class HomeView: UIView {

    // MARK: Public properties

    weak var delegate: HomeViewDelegate?
}
