import UIKit

protocol SettingsViewDelegate: AnyObject {
    func didTapOnDelete()
    func didTapOnLogout()
    func didTapOnEditProfile()
}

final class SettingsView: UIView {

    weak var delegate: SettingsViewDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Settings"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = Theme.Colors.blackText
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
