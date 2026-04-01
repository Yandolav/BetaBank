import UIKit

protocol TextFieldsStackDelegate: AnyObject {
    func firstNameTextFieldValidate(text: String?)
    func emailTextFieldValidate(text: String?)
    func lastNameTextFieldValidate(text: String?)
    func passwordTextFieldValidate(text: String?)
    func sumbit()
}

final class TextFieldsStack: UIView {

    // MARK: Public properties

    weak var delegate: TextFieldsStackDelegate?

    var firstNameTextFieldText: String? {
        firstNameTextField.textFieldText
    }

    var lastNameTextFieldText: String? {
        lastNameTextField.textFieldText
    }

    var emailTextFieldText: String? {
        emailTextField.textFieldText
    }

    var passwordTextFieldText: String? {
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
        stack.spacing = DS.Spacing.sm
        stack.distribution = .equalSpacing
        return stack
    }()

    private let firstNameTextField: DSInputTextField = {
        let textField = DSInputTextField(style: .plain)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityIdentifier = Constants.FirstNameTextFieldAccessibilityIdentifier
        return textField
    }()

    private let lastNameTextField: DSInputTextField = {
        let textField = DSInputTextField(style: .plain)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityIdentifier = Constants.LastNameTextFieldAccessibilityIdentifier
        return textField
    }()

    private let emailTextField: DSInputTextField = {
        let textField = DSInputTextField(style: .plain)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityIdentifier = Constants.EmailTextFieldAccessibilityIdentifier
        return textField
    }()

    private let passwordTextField: DSInputTextField = {
        let textField = DSInputTextField(style: .secure)
        textField.translatesAutoresizingMaskIntoConstraints = false
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

    func updateFirstNameTextFieldsState(state: DSInputTextField.TextFieldState) {
        if case .success = state { validateFirstName = true } else { validateFirstName = false }
        firstNameTextField.changeState(state: state)
    }

    func updateLastNameTextFieldsState(state: DSInputTextField.TextFieldState) {
        if case .success = state { validateLastName = true } else { validateLastName = false }
        lastNameTextField.changeState(state: state)
    }

    func updateEmailTextFieldsState(state: DSInputTextField.TextFieldState) {
        if case .success = state { validateEmail = true } else { validateEmail = false }
        emailTextField.changeState(state: state)
    }

    func updatePasswordTextFieldsState(state: DSInputTextField.TextFieldState) {
        if case .success = state { validatePassword = true } else { validatePassword = false }
        passwordTextField.changeState(state: state)
    }

    func showOnlyLoginAndPassword(toShow: Bool) {
        firstNameTextField.isHidden = toShow
        lastNameTextField.isHidden = toShow
    }

    func clearTextFields() {
        textFieldsStack.arrangedSubviews.forEach { ($0 as? DSInputTextField)?.textFieldText = "" }
    }

    func changeNormalModeTextFields() {
        textFieldsStack.arrangedSubviews.forEach { ($0 as? DSInputTextField)?.changeState(state: .normal) }
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
        firstNameTextField.configure(with: .init(
            title: Constants.firstNameTitle,
            placeholder: Constants.firstNamePlaceholder,
            returnKeyType: .next,
            onReturn: { [weak self] _ in self?.lastNameTextField.show() },
            onTextChange: { [weak self] in self?.delegate?.firstNameTextFieldValidate(text: $0.textFieldText) }
        ))

        lastNameTextField.configure(with: .init(
            title: Constants.lastNameTitle,
            placeholder: Constants.lastNamePlaceholder,
            returnKeyType: .next,
            onReturn: { [weak self] _ in self?.emailTextField.show() },
            onTextChange: { [weak self] in self?.delegate?.lastNameTextFieldValidate(text: $0.textFieldText) }
        ))

        emailTextField.configure(with: .init(
            title: Constants.emailTitle,
            placeholder: Constants.emailPlaceholder,
            returnKeyType: .next,
            onReturn: { [weak self] _ in self?.passwordTextField.show() },
            onTextChange: { [weak self] in self?.delegate?.emailTextFieldValidate(text: $0.textFieldText) }
        ))

        passwordTextField.configure(with: .init(
            title: Constants.passwordTitle,
            placeholder: Constants.passwordPlaceholder,
            returnKeyType: .done,
            onReturn: { [weak self] in
                $0.hide()
                self?.delegate?.sumbit()
            },
            onTextChange: { [weak self] in self?.delegate?.passwordTextFieldValidate(text: $0.textFieldText) }
        ))
    }
}

// MARK: - Constants

private extension TextFieldsStack {
    enum Constants {
        static let firstNameTitle = "Имя"
        static let firstNamePlaceholder = "Введите ваше имя"

        static let lastNameTitle = "Фамилия"
        static let lastNamePlaceholder = "Введите вашу фамилию"

        static let emailTitle = "Почта"
        static let emailPlaceholder = "Введите вашу почту"

        static let passwordTitle = "Пароль"
        static let passwordPlaceholder = "Введите ваш пароль"

        static let FirstNameTextFieldAccessibilityIdentifier = "Auth.FirstNameTextField"
        static let LastNameTextFieldAccessibilityIdentifier = "Auth.LastNameTextField"
        static let EmailTextFieldAccessibilityIdentifier = "Auth.EmailTextField"
        static let PasswordTextFieldAccessibilityIdentifier = "Auth.PasswordTextField"
    }
}
