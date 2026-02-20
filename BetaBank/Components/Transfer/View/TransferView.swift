import UIKit

import Foundation

protocol TransferViewDelegate: AnyObject {
    func transfer(
        amountMinor: Int,
        comment: String?,
        fromCard: UUID,
        toCard: UUID
    )
}

final class TransferView: UIView {

    // MARK: Public properties

    weak var delegate: TransferViewDelegate?
}


