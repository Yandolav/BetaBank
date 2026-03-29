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
        view.layer.borderWidth = 1
        view.layer.cornerRadius = DS.Radius.m
        return view
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.textColor = DS.Colors.blackText
        textField.font = DS.Fonts.body
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()

    private let rightAccessory: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = DS.Colors.accentColor
        button.isHidden = true
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.caption)
        return label
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.error)
        label.numberOfLines = 3
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
        buttonImage: UIImage? = nil,
        buttonAction: ((InputTextField) -> Void)? = nil,
        returnAction: ((InputTextField) -> Void)? = nil,
        validateAction: ((InputTextField) -> Void)? = nil
    ) {
        titleLabel.text = title

        let text = NSAttributedString(
            string: placeholder,
            attributes: [
                .font: DS.Fonts.body,
                .foregroundColor: DS.Colors.placeholderTextColor
            ]
        )
        textField.attributedPlaceholder = text

        textField.returnKeyType = returnKeyType

        if let buttonImage {
            rightAccessory.setImage(buttonImage, for: .normal)
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
            container.layer.borderColor = DS.Colors.defaultBorderColor.cgColor
            errorLabel.text = ""
            errorLabel.isHidden = true
        case .success:
            container.layer.borderColor = DS.Colors.successColor.cgColor
            errorLabel.text = ""
            errorLabel.isHidden = true
        case .error(let errorMessage):
            container.layer.borderColor = DS.Colors.errorColor.cgColor
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
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.sm),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            container.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DS.Spacing.xs),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),

            textField.topAnchor.constraint(equalTo: container.topAnchor),
            textField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: DS.Spacing.sm),
            textField.trailingAnchor.constraint(equalTo: rightAccessory.leadingAnchor),
            textField.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            rightAccessory.topAnchor.constraint(equalTo: container.topAnchor, constant: DS.Spacing.sm),
            rightAccessory.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -DS.Spacing.sm),
            rightAccessory.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -DS.Spacing.sm),

            rightAccessory.heightAnchor.constraint(equalToConstant: DS.Spacing.xl),
            rightAccessory.widthAnchor.constraint(equalToConstant: DS.Spacing.xl),

            errorLabel.topAnchor.constraint(equalTo: container.bottomAnchor, constant: DS.Spacing.xs),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.sm),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func changeSecureTextEntry() {
        if textField.isSecureTextEntry {
            rightAccessory.setImage(DS.Icons.passwordHidden, for: .normal)
        } else {
            rightAccessory.setImage(DS.Icons.passwordVisible, for: .normal)
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
