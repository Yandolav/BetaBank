import UIKit

struct DSErrorViewModel {
    let message: String
    let retryTitle: String
    let onRetry: () -> Void

    init(message: String, retryTitle: String = "Повторить", onRetry: @escaping () -> Void) {
        self.message = message
        self.retryTitle = retryTitle
        self.onRetry = onRetry
    }
}

final class DSErrorView: UIView {

    // MARK: Private properties

    private var onRetry: (() -> Void)?

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = DS.Icons.error
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

    private let retryButton: DSActionButton = {
        let button = DSActionButton(style: .filled)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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

    func configure(with viewModel: DSErrorViewModel) {
        messageLabel.text = viewModel.message
        retryButton.configure(with: .init(icon: nil, title: viewModel.retryTitle))
        onRetry = viewModel.onRetry
    }

    // MARK: Private methods

    private func setupView() {
        contentStack.addArrangedSubview(iconImageView)
        contentStack.addArrangedSubview(messageLabel)
        contentStack.addArrangedSubview(retryButton)
        addSubview(contentStack)

        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: DS.Spacing.xxl),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DS.Spacing.xxl),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.xxl),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.xxl),

            iconImageView.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.iconSize),

            retryButton.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.retryButtonMinWidth)
        ])
    }

    @objc private func retryTapped() {
        onRetry?()
    }
}

// MARK: - Constants

private extension DSErrorView {
    enum Constants {
        static let iconSize: CGFloat = 60
        static let retryButtonMinWidth: CGFloat = 160
    }
}
