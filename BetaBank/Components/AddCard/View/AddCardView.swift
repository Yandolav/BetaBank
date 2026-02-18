import UIKit

import Foundation

protocol AddCardViewDelegate: AnyObject {
    func didTapOnSave(
        userFullName: String,
        bankName: String
    )
}

final class AddCardView: UIView {

    // MARK: Public properties

    weak var delegate: AddCardViewDelegate?
}

