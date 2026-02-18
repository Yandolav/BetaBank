import UIKit

protocol SettingsViewDelegate: AnyObject {
    func didTapOnDelete()
    func didTapOnLogout()
    func didTapOnEditProfile()
}

final class SettingsView: UIView {

    // MARK: Public properties

    weak var delegate: SettingsViewDelegate?
}
