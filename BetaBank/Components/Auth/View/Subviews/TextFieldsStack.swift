import UIKit

protocol TextFieldsStackDelegate: AnyObject {
    func firstNameTextFieldValidate(text: String)
    func emailTextFieldValidate(text: String)
    func lastNameTextFieldValidate(text: String)
    func passwordTextFieldValidate(text: String)
    func sumbit()
}

final class TextFieldsStack: UIView {

    // MARK: Public properties

    weak var delegate: TextFieldsStackDelegate?

    var firstNameTextFieldText: String {
        firstNameTextField.textFieldText
    }

    var lastNameTextFieldText: String {
        lastNameTextField.textFieldText
    }

    var emailTextFieldText: String {
        emailTextField.textFieldText
    }

    var passwordTextFieldText: String {
        passwordTextField.textFieldText
    }

    var allTextFieldsValid: Bool {
        validateFirstName && validateLastName && validateEmail && validatePassword
    }

    var passwordAndEmailTextFieldsValid: Bool {
        validateEmail && validatePassword
    }

    // MARK: Private properties

    private var validateFirstName = false
    private var validateLastName = false
    private var validateEmail = false
    private var validatePassword = false

    private let textFieldsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.textFieldsStackSpacing
        stack.distribution = .equalSpacing
        return stack
    }()

    private let firstNameTextField: InputTextField = {
        let textField = InputTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityIdentifier = Constants.FirstNameTextFieldAccessibilityIdentifier
        return textField
    }()

    private let lastNameTextField: InputTextField = {
        let textField = InputTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityIdentifier = Constants.LastNameTextFieldAccessibilityIdentifier
        return textField
    }()

    private let emailTextField: InputTextField = {
        let textField = InputTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityIdentifier = Constants.EmailTextFieldAccessibilityIdentifier
        return textField
    }()

    private let passwordTextField: InputTextField = {
        let textField = InputTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.accessibilityIdentifier = Constants.PasswordTextFieldAccessibilityIdentifier
        return textField
    }()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupTextFields()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    func updateFirstNameTextFieldsState(state: InputTextField.TextFieldState) {
        if case .success = state {
            validateFirstName = true
        } else {
            validateFirstName = false
        }
        firstNameTextField.changeState(state: state)
    }

    func updateLastNameTextFieldsState(state: InputTextField.TextFieldState) {
        if case .success = state {
            validateLastName = true
        } else {
            validateLastName = false
        }
        lastNameTextField.changeState(state: state)
    }

    func updateEmailTextFieldsState(state: InputTextField.TextFieldState) {
        if case .success = state {
            validateEmail = true
        } else {
            validateEmail = false
        }
        emailTextField.changeState(state: state)
    }

    func updatePasswordTextFieldsState(state: InputTextField.TextFieldState) {
        if case .success = state {
            validatePassword = true
        } else {
            validatePassword = false
        }
        passwordTextField.changeState(state: state)
    }

    func showOnlyLoginAndPassword(toShow: Bool) {
        firstNameTextField.isHidden = toShow
        lastNameTextField.isHidden = toShow
    }

    func clearTextFields() {
        textFieldsStack.arrangedSubviews.forEach { ($0 as? InputTextField)?.textFieldText = "" }
    }

    func changeNormalModeTextFields() {
        textFieldsStack.arrangedSubviews.forEach { ($0 as? InputTextField)?.changeState(state: .normal) }
    }

    func switchAllFlagsToFalse() {
        validateFirstName = false
        validateLastName = false
        validateEmail = false
        validatePassword = false
    }

    // MARK: Private methods

    private func setupView() {
        addSubview(textFieldsStack)
        textFieldsStack.addArrangedSubview(firstNameTextField)
        textFieldsStack.addArrangedSubview(lastNameTextField)
        textFieldsStack.addArrangedSubview(emailTextField)
        textFieldsStack.addArrangedSubview(passwordTextField)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textFieldsStack.topAnchor.constraint(equalTo: topAnchor),
            textFieldsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            textFieldsStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            textFieldsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupTextFields() {
        firstNameTextField.configure(
            title: Constants.firstNameTitle,
            placeholder: Constants.firstNamePlaceholder,
            returnKeyType: .next,
            buttonImageName: Constants.clearTextIcon,
            buttonAction: {
                $0.textFieldText = ""
                $0.changeState(state: .normal)
            },
            returnAction: { [weak self] _ in
                guard let self else { return }
                lastNameTextField.show()
            },
            validateAction: { [weak self] in
                guard let self else { return }
                delegate?.firstNameTextFieldValidate(text: $0.textFieldText)
            }
        )

        lastNameTextField.configure(
            title: Constants.lastNameTitle,
            placeholder: Constants.lastNamePlaceholder,
            returnKeyType: .next,
            buttonImageName: Constants.clearTextIcon,
            buttonAction: {
                $0.textFieldText = ""
                $0.changeState(state: .normal)
            },
            returnAction: { [weak self] _ in
                guard let self else { return }
                emailTextField.show()
            },
            validateAction: { [weak self] in
                guard let self else { return }
                delegate?.lastNameTextFieldValidate(text: $0.textFieldText)
            }
        )

        emailTextField.configure(
            title: Constants.emailTitle,
            placeholder: Constants.emailPlaceholder,
            returnKeyType: .next,
            buttonImageName: Constants.clearTextIcon,
            buttonAction: {
                $0.textFieldText = ""
                $0.changeState(state: .normal)
            },
            returnAction: { [weak self] _ in
                guard let self else { return }
                passwordTextField.show()
            },
            validateAction: { [weak self] in
                guard let self else { return }
                delegate?.emailTextFieldValidate(text: $0.textFieldText)
            }
        )

        passwordTextField.configure(
            title: Constants.passwordTitle,
            placeholder: Constants.passwordPlaceholder,
            returnKeyType: .done,
            buttonImageName: Constants.passwordInvisibleIcon,
            buttonAction: {
                $0.isSecureTextEntry = !$0.isSecureTextEntry
            },
            returnAction: { [weak self] in
                guard let self else { return }

                $0.hide()
                delegate?.sumbit()
            },
            validateAction: { [weak self] in
                guard let self else { return }
                delegate?.passwordTextFieldValidate(text: $0.textFieldText)
            }
        )
    }
}

// MARK: - Constants

private extension TextFieldsStack {
    enum Constants {
        static let textFieldsStackSpacing: CGFloat = 10

        static let clearTextIcon: String = "xmark.circle.fill"
        static let passwordInvisibleIcon: String = "eye.slash.fill"

        static let firstNameTitle: String = "Имя"
        static let firstNamePlaceholder: String = "Введите ваше имя"

        static let lastNameTitle: String = "Фамилия"
        static let lastNamePlaceholder: String = "Введите вашу фамилию"

        static let emailTitle: String = "Почта"
        static let emailPlaceholder: String = "Введите вашу почту"

        static let passwordTitle: String = "Пароль"
        static let passwordPlaceholder: String = "Введите ваш пароль"

        static let FirstNameTextFieldAccessibilityIdentifier = "Auth.FirstNameTextField"
        static let LastNameTextFieldAccessibilityIdentifier = "Auth.LastNameTextField"
        static let EmailTextFieldAccessibilityIdentifier = "Auth.EmailTextField"
        static let PasswordTextFieldAccessibilityIdentifier = "Auth.PasswordTextField"
    }
}
