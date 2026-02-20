import UIKit

protocol EditProfileViewDelegate: AnyObject {
    func didTapOnChange()
    func didTapOnSave(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        phone: String?,
        dataImage: Data?
    )
}

final class EditProfileView: UIView {

    // MARK: Public properties

    weak var delegate: EditProfileViewDelegate?
}
