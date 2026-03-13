import UIKit

protocol AuthViewDelegate: AnyObject {
    func didTapSignIn(
        email: String,
        password: String
    )
    func didTapSignUp(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    )
    func firstNameTextFieldValidate(text: String)
    func lastNameTextFieldValidate(text: String)
    func emailTextFieldValidate(text: String)
    func passwordTextFieldValidate(text: String)
}

final class AuthView: UIView {

    // MARK: Public properties

    weak var delegate: AuthViewDelegate?

    // MARK: Private properties

    private var currentState: AuthState = .singIn {
        didSet {
            changeState(state: currentState)
        }
    }

    private var validateFirstName = false
    private var validateLastName = false
    private var validateEmail = false
    private var validatePassword = false

    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let titlesStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.titlesStackSpacing
        stack.distribution = .equalSpacing
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.Colors.blackText
        label.font = Theme.Fonts.title
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Theme.Fonts.body
        label.textColor = Theme.Colors.defaultTextColor
        label.numberOfLines = Constants.subtitleNumberOfLines
        return label
    }()

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
        setupKeyboardObservers()
        setupTextFields()
        enableSubmitButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Deinit

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    // MARK: Public methods

    func sumbitError(errorMessage: String) {
        submitErrorLabel.text = errorMessage
        submitErrorLabel.isHidden = false
        self.isUserInteractionEnabled = true
        enableSubmitButton()
    }

    func validateFirstNameField(textFieldState: InputTextField.TextFieldState) {
        if case .success = textFieldState {
            validateFirstName = true
        } else {
            validateFirstName = false
        }
        enableSubmitButton()
        firstNameTextField.changeState(state: textFieldState)
    }

    func validateLastNameField(textFieldState: InputTextField.TextFieldState) {
        if case .success = textFieldState {
            validateLastName = true
        } else {
            validateLastName = false
        }
        enableSubmitButton()
        lastNameTextField.changeState(state: textFieldState)
    }

    func validateEmailField(textFieldState: InputTextField.TextFieldState) {
        if case .success = textFieldState {
            validateEmail = true
        } else {
            validateEmail = false
        }
        enableSubmitButton()
        emailTextField.changeState(state: textFieldState)
    }

    func validatePasswordField(textFieldState: InputTextField.TextFieldState) {
        if case .success = textFieldState {
            validatePassword = true
        } else {
            validatePassword = false
        }
        enableSubmitButton()
        passwordTextField.changeState(state: textFieldState)
    }

    // MARK: Private methods

    private func setupView() {
        self.backgroundColor = .white

        self.addSubview(scrollView)

        currentState = .singIn

        scrollView.addSubview(container)

        container.addSubview(titlesStack)
        container.addSubview(textFieldsStack)
        container.addSubview(submitErrorLabel)
        container.addSubview(submitButton)
        container.addSubview(infoStack)

        titlesStack.addArrangedSubview(titleLabel)
        titlesStack.addArrangedSubview(subtitleLabel)

        textFieldsStack.addArrangedSubview(firstNameTextField)
        textFieldsStack.addArrangedSubview(lastNameTextField)
        textFieldsStack.addArrangedSubview(emailTextField)
        textFieldsStack.addArrangedSubview(passwordTextField)

        infoStack.addArrangedSubview(infoTextLabel)
        infoStack.addArrangedSubview(infoActionLabel)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)

        infoActionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapInfoAction)))

        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.scrollViewTopInset),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            container.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            container.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            titlesStack.topAnchor.constraint(equalTo: container.topAnchor),
            titlesStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.titlesHorizontalInset),
            titlesStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Constants.titlesHorizontalInset),

            textFieldsStack.topAnchor.constraint(equalTo: titlesStack.bottomAnchor, constant: Constants.sectionSpacing),
            textFieldsStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.textFieldsHorizontalInset),
            textFieldsStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Constants.textFieldsHorizontalInset),

            submitErrorLabel.topAnchor.constraint(equalTo: textFieldsStack.bottomAnchor, constant: Constants.sectionSpacing),
            submitErrorLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.submitErrorLabelHorizontalInset),
            submitErrorLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Constants.submitErrorLabelHorizontalInset),

            submitButton.topAnchor.constraint(equalTo: submitErrorLabel.bottomAnchor, constant: Constants.submitButtonTopSpacing),
            submitButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.submitButtonHorizontalInset),
            submitButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Constants.submitButtonHorizontalInset),

            infoStack.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: Constants.infoTopSpacing),
            infoStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.infoHorizontalInset),
            infoStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Constants.infoHorizontalInset),
            infoStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.containerBottomInset)
        ])
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
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
                self.lastNameTextField.show()
            },
            validateAction: { [weak self] in
                guard let self else { return }
                self.delegate?.firstNameTextFieldValidate(text: $0.textFieldText)
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
                self.emailTextField.show()
            },
            validateAction: { [weak self] in
                guard let self else { return }
                self.delegate?.lastNameTextFieldValidate(text: $0.textFieldText)
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
                self.passwordTextField.show()
            },
            validateAction: { [weak self] in
                guard let self else { return }
                self.delegate?.emailTextFieldValidate(text: $0.textFieldText)
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
                if self.submitButton.isEnabled {
                    self.submit()
                }
            },
            validateAction: { [weak self] in
                guard let self else { return }
                self.delegate?.passwordTextFieldValidate(text: $0.textFieldText)
            }
        )
    }

    private func changeState(state: AuthState) {
        switch state {
        case .singIn:
            applySignInMode()
        case .signUp:
            applySignUpMode()
        }
    }

    private func applySignInMode() {
        titleLabel.text = Constants.signInTitle
        subtitleLabel.text = Constants.signInSubtitle
        firstNameTextField.isHidden = true
        lastNameTextField.isHidden = true
        submitButton.changeText(text: Constants.signInButtonText)
        infoTextLabel.text = Constants.signInInfoPrefix
        infoActionLabel.text = Constants.signInInfoAction
        clearTextFields()
        submitErrorLabel.text = ""
        submitErrorLabel.isHidden = true
        changeNormalModeTextFields()
        switchAllFlagsToFalse()
    }

    private func applySignUpMode() {
        titleLabel.text = Constants.signUpTitle
        subtitleLabel.text = Constants.signUpSubtitle
        firstNameTextField.isHidden = false
        lastNameTextField.isHidden = false
        submitButton.changeText(text: Constants.signUpButtonText)
        infoTextLabel.text = Constants.signUpInfoPrefix
        infoActionLabel.text = Constants.signUpInfoAction
        clearTextFields()
        submitErrorLabel.text = ""
        submitErrorLabel.isHidden = true
        changeNormalModeTextFields()
        switchAllFlagsToFalse()
    }

    private func clearTextFields() {
        textFieldsStack.arrangedSubviews.forEach { ($0 as? InputTextField)?.textFieldText = "" }
    }

    private func changeNormalModeTextFields() {
        textFieldsStack.arrangedSubviews.forEach { ($0 as? InputTextField)?.changeState(state: .normal) }
    }

    private func switchAllFlagsToFalse() {
        validateFirstName = false
        validateLastName = false
        validateEmail = false
        validatePassword = false
        enableSubmitButton()
    }

    private func enableSubmitButton() {
        switch currentState {
        case .singIn:
            if validateEmail, validatePassword {
                submitButton.currentState = .enable
            } else {
                submitButton.currentState = .disable
            }
        case .signUp:
            if validateEmail, validatePassword, validateFirstName, validateLastName {
                submitButton.currentState = .enable
            } else {
                submitButton.currentState = .disable
            }
        }
    }

    @objc private func keyboardWillChangeFrame(_ note: Notification) {
        guard let userInfo = note.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        let keyboardInView = self.convert(endFrame, from: nil)
        let intersection = self.bounds.intersection(keyboardInView)
        scrollView.contentInset.bottom = intersection.height
        scrollView.verticalScrollIndicatorInsets.bottom = intersection.height
    }

    @objc private func submit() {
        submitButton.currentState = .loading
        self.isUserInteractionEnabled = false
        switch currentState {
        case .singIn:
            delegate?.didTapSignIn(
                email: emailTextField.textFieldText,
                password: passwordTextField.textFieldText
            )
        case .signUp:
            delegate?.didTapSignUp(
                firstName: firstNameTextField.textFieldText,
                lastName: lastNameTextField.textFieldText,
                email: emailTextField.textFieldText,
                password: passwordTextField.textFieldText
            )
        }
    }

    @objc private func didTapInfoAction() {
        self.endEditing(true)
        switch currentState {
        case .singIn:
            currentState = .signUp
        case .signUp:
            currentState = .singIn
        }
    }

    @objc private func didTapBackground() {
        endEditing(true)
    }
}

// MARK: - AuthState

private extension AuthView {
    enum AuthState {
        case singIn
        case signUp
    }
}

// MARK: - Constants

private extension AuthView {
    enum Constants {
        static let titlesStackSpacing: CGFloat = 10
        static let textFieldsStackSpacing: CGFloat = 10
        static let subtitleNumberOfLines: Int = 0

        static let titlesHorizontalInset: CGFloat = 30
        static let textFieldsHorizontalInset: CGFloat = 20
        static let submitButtonHorizontalInset: CGFloat = 40
        static let infoHorizontalInset: CGFloat = 20

        static let sectionSpacing: CGFloat = 50
        static let infoTopSpacing: CGFloat = 10
        static let containerBottomInset: CGFloat = 20

        static let infoStackSpacing: CGFloat = 1
        static let infoTextNumberOfLines: Int = 0

        static let errorLabelNumberOfLines: Int = 0

        static let scrollViewTopInset: CGFloat = 50
        static let submitErrorLabelHorizontalInset: CGFloat = 20
        static let submitButtonTopSpacing: CGFloat = 5

        static let signInInfoPrefix: String = "У вас нету аккаунта?"
        static let signInInfoAction: String = "Зарегистрируйтесь"

        static let signUpInfoPrefix: String = "У вас есть аккаунт?"
        static let signUpInfoAction: String = "Войдите"

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

        static let signInTitle: String = "С возвращением!"
        static let signInSubtitle: String = "Введите данные, под которыми вы регистрировались ранее."
        static let signInButtonText: String = "Войти"
        static let signInInfoText: String = "Нет аккаунта? Зарегистрируйтесь."

        static let signUpTitle: String = "Добро пожаловать!"
        static let signUpSubtitle: String = "Введите данные, чтобы зарегистрироваться."
        static let signUpButtonText: String = "Зарегистрироваться"
        static let signUpInfoText: String = "Уже есть аккаунт? Войдите."

        static let FirstNameTextFieldAccessibilityIdentifier = "Auth.FirstNameTextField"
        static let LastNameTextFieldAccessibilityIdentifier = "Auth.LastNameTextField"
        static let EmailTextFieldAccessibilityIdentifier = "Auth.EmailTextField"
        static let PasswordTextFieldAccessibilityIdentifier = "Auth.PasswordTextField"
        static let submitButtonAccessibilityIdentifier = "Auth.SubmitButton"
        static let infoActionLabelAccessibilityIdentifier = "Auth.InfoActionLabel"
    }
}
