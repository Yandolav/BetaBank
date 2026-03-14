import UIKit

protocol SubmitStackDelegate: AnyObject {
    func didTapSubmitButton()
}

final class SubmitStack: UIView {

    // MARK: Public properties

    weak var delegate: SubmitStackDelegate?

    var submitButtonCurrentState: MainAppButton.MainAppButtonState {
        get { submitButton.currentState }
        set { submitButton.currentState = newValue }
    }

    // MARK: Private propertis

    private let submitStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.submitStackSpacing
        stack.alignment = .fill
        return stack
    }()

    private let submitButton: MainAppButton = {
        let button = MainAppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = Constants.submitButtonAccessibilityIdentifier
        return button
    }()

    private let submitErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Fonts.caption
        label.textColor = Theme.Colors.errorColor
        label.numberOfLines = Constants.errorLabelNumberOfLines
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

    // MARK: Public method

    func configureErrorLabel(isHidden: Bool, errorMessage: String) {
        submitErrorLabel.text = errorMessage
        submitErrorLabel.isHidden = isHidden
    }

    func changeSubmitButtonText(text: String) {
        submitButton.changeText(text: text)
    }

    // MARK: Private methods

    private func setupView() {
        addSubview(submitStack)
        submitStack.addArrangedSubview(submitButton)
        submitStack.addArrangedSubview(submitErrorLabel)

        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            submitStack.topAnchor.constraint(equalTo: topAnchor),
            submitStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            submitStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            submitStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc private func submit() {
        delegate?.didTapSubmitButton()
    }
}

// MARK: - Constants

private extension SubmitStack {
    enum Constants {
        static let submitStackSpacing: CGFloat = 5

        static let errorLabelNumberOfLines: Int = 0

        static let submitButtonAccessibilityIdentifier = "Auth.SubmitButton"
    }
}
