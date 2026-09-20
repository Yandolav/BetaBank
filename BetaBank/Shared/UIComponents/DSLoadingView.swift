import UIKit

struct DSLoadingViewModel {
    let message: String?

    init(message: String? = nil) {
        self.message = message
    }
}

final class DSLoadingView: UIView {

    // MARK: Private properties

    private let loadingIndicator: UIActivityIndicatorView = {
        let iv = UIActivityIndicatorView(style: .large)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.color = DS.Colors.accentColor
        iv.hidesWhenStopped = true
        return iv
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.caption)
        label.textAlignment = .center
        label.isHidden = true
        return label
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

    func configure(with viewModel: DSLoadingViewModel) {
        messageLabel.text = viewModel.message
    }

    func show() {
        isHidden = false
        loadingIndicator.startAnimating()
    }

    func hide() {
        isHidden = true
        loadingIndicator.stopAnimating()
    }

    // MARK: Private methods

    private func setupView() {
        addSubview(loadingIndicator)
        addSubview(messageLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -DS.Spacing.m),

            messageLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: DS.Spacing.s),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.xl),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.xl)
        ])
    }
}
