import UIKit

class InputTextField: UIView {

    // MARK: Public properties

    var isSecureTextEntry: Bool {
        get {
            textField.isSecureTextEntry
        }

        set {
            textField.isSecureTextEntry = newValue
            changeSecureTextEntry()
        }
    }

    var textFieldText: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    // MARK: Private properties

    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderWidth = Constants.containerBorderWidth
        view.layer.cornerRadius = Constants.containerCornerRadius
        return view
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.textColor = Theme.Colors.blackText
        textField.font = Theme.Fonts.body
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()

    private let rightAccessory: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Theme.Colors.accentColor
        button.isHidden = true
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Fonts.body
        label.textColor = Theme.Colors.defaultTextColor
        return label
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Fonts.caption
        label.textColor = Theme.Colors.errorColor
        label.numberOfLines = Constants.errorLabelNumberOfLines
        label.isHidden = true
        return label
    }()

    private var buttonAction: ((InputTextField) -> Void)?
    private var returnAction: ((InputTextField) -> Void)?
    private var validateAction: ((InputTextField) -> Void)?

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    func configure(
        title: String,
        placeholder: String,
        returnKeyType: UIReturnKeyType,
        buttonImageName: String? = nil,
        buttonAction: ((InputTextField) -> Void)? = nil,
        returnAction: ((InputTextField) -> Void)? = nil,
        validateAction: ((InputTextField) -> Void)? = nil
    ) {
        titleLabel.text = title

        let text = NSAttributedString(
            string: placeholder,
            attributes: [
                .font: Theme.Fonts.body,
                .foregroundColor: Theme.Colors.placeholderTextColor
            ]
        )
        textField.attributedPlaceholder = text

        textField.returnKeyType = returnKeyType

        if let buttonImageName {
            rightAccessory.setImage(UIImage(systemName: buttonImageName), for: .normal)
            rightAccessory.isHidden = false
        } else {
            rightAccessory.isHidden = true
        }

        self.buttonAction = buttonAction
        self.returnAction = returnAction
        self.validateAction = validateAction

        changeState(state: .normal)
    }

    func changeState(state: TextFieldState) {
        switch state {
        case .normal:
            container.layer.borderColor = Theme.Colors.defaultBorderColor.cgColor
            errorLabel.text = ""
            errorLabel.isHidden = true
        case .success:
            container.layer.borderColor = Theme.Colors.successColor.cgColor
            errorLabel.text = ""
            errorLabel.isHidden = true
        case .error(let errorMessage):
            container.layer.borderColor = Theme.Colors.errorColor.cgColor
            errorLabel.text = errorMessage
            errorLabel.isHidden = false
        }
    }

    func show() {
        textField.becomeFirstResponder()
    }

    func hide() {
        textField.resignFirstResponder()
    }

    // MARK: Private methods

    private func setupView() {
        backgroundColor = .clear
        textField.delegate = self

        addSubview(container)
        addSubview(titleLabel)
        addSubview(errorLabel)

        container.addSubview(textField)
        container.addSubview(rightAccessory)

        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        rightAccessory.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.titleLabelLeading),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            container.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.containerTopSpacing),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),

            textField.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.textFieldVerticalInset),
            textField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.textFieldLeading),
            textField.trailingAnchor.constraint(equalTo: rightAccessory.leadingAnchor),
            textField.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.textFieldVerticalInset),

            rightAccessory.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.rightAccessoryVerticalInset),
            rightAccessory.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Constants.rightAccessoryTrailing),
            rightAccessory.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.rightAccessoryVerticalInset),

            rightAccessory.heightAnchor.constraint(equalToConstant: Constants.rightAccessorySize),
            rightAccessory.widthAnchor.constraint(equalToConstant: Constants.rightAccessorySize),

            errorLabel.topAnchor.constraint(equalTo: container.bottomAnchor, constant: Constants.errorLabelTopSpacing),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.errorLabelLeading),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func changeSecureTextEntry() {
        if textField.isSecureTextEntry {
            rightAccessory.setImage(UIImage(systemName: Constants.passwordInvisibleIcon), for: .normal)
        } else {
            rightAccessory.setImage(UIImage(systemName: Constants.passwordVisibleIcon), for: .normal)
        }
    }

    @objc private func tapButton() {
        buttonAction?(self)
    }

    @objc private func textDidChange() {
        validateAction?(self)
    }
}

// MARK: - TextFieldState

extension InputTextField {
    enum TextFieldState {
        case normal
        case error(errorMessage: String)
        case success
    }
}

// MARK: - UITextFieldDelegate

extension InputTextField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text ?? "").isEmpty {
            changeState(state: .normal)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        returnAction?(self)
        return false
    }
}

// MARK: - Constants

private extension InputTextField {
    enum Constants {
        static let containerBorderWidth: CGFloat = 1
        static let containerCornerRadius: CGFloat = 15

        static let titleLabelLeading: CGFloat = 10
        static let containerTopSpacing: CGFloat = 5

        static let textFieldVerticalInset: CGFloat = 0
        static let textFieldLeading: CGFloat = 10

        static let rightAccessoryVerticalInset: CGFloat = 10
        static let rightAccessoryTrailing: CGFloat = 10
        static let rightAccessorySize: CGFloat = 24

        static let errorLabelTopSpacing: CGFloat = 5
        static let errorLabelLeading: CGFloat = 10

        static let errorLabelNumberOfLines: Int = 3

        static let passwordInvisibleIcon: String = "eye.slash.fill"
        static let passwordVisibleIcon: String = "eye.fill"
    }
}
