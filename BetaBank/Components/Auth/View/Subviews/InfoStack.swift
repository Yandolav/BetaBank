import UIKit

protocol InfoStackDelegate: AnyObject {
    func didTapInfoActionLabel()
}

final class InfoStack: UIView {

    // MARK: Public properties

    weak var delegate: InfoStackDelegate?

    // MARK: Private properties

    private let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.infoStackSpacing
        stack.alignment = .center
        return stack
    }()

    private let infoTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Fonts.caption
        label.textColor = Theme.Colors.defaultTextColor
        label.numberOfLines = Constants.infoTextNumberOfLines
        return label
    }()

    private let infoActionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Fonts.caption
        label.textColor = Theme.Colors.accentColor
        label.isUserInteractionEnabled = true
        label.accessibilityIdentifier = Constants.infoActionLabelAccessibilityIdentifier
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

    func configure(infoText: String, infoActionText: String) {
        infoTextLabel.text = infoText
        infoActionLabel.text = infoActionText
    }

    // MARK: Private methods

    private func setupView() {
        addSubview(infoStack)
        infoStack.addArrangedSubview(infoTextLabel)
        infoStack.addArrangedSubview(infoActionLabel)

        infoActionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapInfoAction)))
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            infoStack.topAnchor.constraint(equalTo: topAnchor),
            infoStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc private func didTapInfoAction() {
        delegate?.didTapInfoActionLabel()
    }
}

// MARK: - Constants

private extension InfoStack {
    enum Constants {
        static let infoStackSpacing: CGFloat = 1
        static let infoTextNumberOfLines: Int = 0
        static let infoActionLabelAccessibilityIdentifier = "Auth.InfoActionLabel"
    }
}
