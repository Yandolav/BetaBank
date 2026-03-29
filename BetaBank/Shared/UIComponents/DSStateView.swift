import UIKit

final class DSStateView: UIView {
    enum State {
        case loading(message: String? = nil)
        case error(message: String, retryTitle: String = "Повторить")
        case empty(message: String = "Нет данных")
        case hidden
    }

    var onRetry: (() -> Void)?

    private let loadingIndicator: UIActivityIndicatorView = {
        let iv = UIActivityIndicatorView(style: .large)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.color = DS.Colors.accentColor
        iv.hidesWhenStopped = true
        return iv
    }()

    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.caption)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
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

    private let retryButton: MainAppButton = {
        let button = MainAppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.changeText(text: "Повторить")
        button.isHidden = true
        return button
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconImageView, messageLabel, retryButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = DS.Spacing.m
        stack.isHidden = true
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setState(_ state: State) {
        switch state {

        case .hidden:
            isHidden = true
            loadingIndicator.stopAnimating()

        case .loading(let message):
            isHidden = false
            contentStack.isHidden = true
            loadingIndicator.startAnimating()
            loadingLabel.text = message
            loadingLabel.isHidden = (message == nil)

        case .empty(let message):
            isHidden = false
            contentStack.isHidden = false
            loadingIndicator.stopAnimating()
            loadingLabel.isHidden = true
            iconImageView.image = DS.Icons.empty
            messageLabel.text = message
            retryButton.isHidden = true

        case .error(let message, let retryTitle):
            isHidden = false
            contentStack.isHidden = false
            loadingIndicator.stopAnimating()
            loadingLabel.isHidden = true
            iconImageView.image = DS.Icons.error
            messageLabel.text = message
            retryButton.changeText(text: retryTitle)
            retryButton.isHidden = false
        }
    }

    private func setupView() {
        backgroundColor = .clear
        addSubview(loadingIndicator)
        addSubview(loadingLabel)
        addSubview(contentStack)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -DS.Spacing.m),

            loadingLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: DS.Spacing.s),
            loadingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.xl),
            loadingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.xl),

            contentStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.xxl),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.xxl),

            iconImageView.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.iconSize),

            retryButton.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.retryButtonMinWidth)
        ])
    }

    @objc private func retryTapped() { onRetry?() }
}

// MARK: - Constants

private extension DSStateView {
    enum Constants {
        static let iconSize: CGFloat = 60
        static let retryButtonMinWidth: CGFloat = 160
    }
}
