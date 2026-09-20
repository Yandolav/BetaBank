import UIKit

struct DSEmptyViewModel {
    let message: String

    init(message: String = "Нет данных") {
        self.message = message
    }
}

final class DSEmptyView: UIView {

    // MARK: Private properties

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = DS.Icons.empty
        iv.tintColor = DS.Colors.defaultBorderColor
        return iv
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.body)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = DS.Spacing.m
        return stack
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

    func configure(with viewModel: DSEmptyViewModel) {
        messageLabel.text = viewModel.message
    }

    // MARK: Private methods

    private func setupView() {
        contentStack.addArrangedSubview(iconImageView)
        contentStack.addArrangedSubview(messageLabel)
        addSubview(contentStack)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.xxl),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.xxl),

            iconImageView.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.iconSize)
        ])
    }
}

// MARK: - Constants

private extension DSEmptyView {
    enum Constants {
        static let iconSize: CGFloat = 60
    }
}
