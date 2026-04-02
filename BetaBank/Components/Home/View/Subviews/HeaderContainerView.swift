import UIKit

final class HeaderContainerView: UIView {

    // MARK: Public properties

    var onProfileTap: (() -> Void)?

    var isProfileHidden: Bool {
        get { profileButton.isHidden }
        set { profileButton.isHidden = newValue }
    }

    // MARK: Private properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.largeTitle)
        return label
    }()

    private let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(DS.Icons.profile, for: .normal)
        button.tintColor = DS.Colors.accentColor
        return button
    }()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    func configure(bankName: String) {
        titleLabel.text = bankName
    }

    // MARK: Private methods

    private func setupView() {
        backgroundColor = DS.Colors.background
        addSubview(titleLabel)
        addSubview(profileButton)
        profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: DS.Spacing.m),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.l),
            titleLabel.trailingAnchor.constraint(equalTo: profileButton.leadingAnchor, constant: -DS.Spacing.m),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DS.Spacing.m),

            profileButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            profileButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.l),
            profileButton.widthAnchor.constraint(equalToConstant: Constants.profileButtonSize),
            profileButton.heightAnchor.constraint(equalToConstant: Constants.profileButtonSize)
        ])
    }

    @objc private func profileTapped() {
        onProfileTap?()
    }
}

// MARK: - Constants

private extension HeaderContainerView {
    enum Constants {
        static let profileButtonSize: CGFloat = 36
    }
}
