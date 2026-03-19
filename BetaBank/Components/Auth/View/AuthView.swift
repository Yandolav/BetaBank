import UIKit

protocol AuthViewDelegate: AnyObject {
    func didTapSignIn(
        email: String?,
        password: String?
    )
    func didTapSignUp(
        firstName: String?,
        lastName: String?,
        email: String?,
        password: String?
    )
    func firstNameTextFieldValidate(text: String?)
    func lastNameTextFieldValidate(text: String?)
    func emailTextFieldValidate(text: String?)
    func passwordTextFieldValidate(text: String?)
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

    private let titlesStack: TitlesStack = {
        let stack = TitlesStack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let textFieldsStack: TextFieldsStack = {
        let stack = TextFieldsStack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let submitStack: SubmitStack = {
        let stack = SubmitStack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let infoStack: InfoStack = {
        let stack = InfoStack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupKeyboardObservers()
        setupDelegate()
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
        submitStack.configureErrorLabel(isHidden: false, errorMessage: errorMessage)
        self.isUserInteractionEnabled = true
        enableSubmitButton()
    }

    func validateFirstNameField(textFieldState: InputTextField.TextFieldState) {
        textFieldsStack.updateFirstNameTextFieldsState(state: textFieldState)
        enableSubmitButton()
    }

    func validateLastNameField(textFieldState: InputTextField.TextFieldState) {
        textFieldsStack.updateLastNameTextFieldsState(state: textFieldState)
        enableSubmitButton()
    }

    func validateEmailField(textFieldState: InputTextField.TextFieldState) {
        textFieldsStack.updateEmailTextFieldsState(state: textFieldState)
        enableSubmitButton()
    }

    func validatePasswordField(textFieldState: InputTextField.TextFieldState) {
        textFieldsStack.updatePasswordTextFieldsState(state: textFieldState)
        enableSubmitButton()
    }

    // MARK: Private methods

    private func setupView() {
        self.backgroundColor = .white

        self.addSubview(scrollView)

        currentState = .singIn

        scrollView.addSubview(container)

        container.addSubview(titlesStack)
        container.addSubview(textFieldsStack)
        container.addSubview(submitStack)
        container.addSubview(infoStack)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
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

            submitStack.topAnchor.constraint(equalTo: textFieldsStack.bottomAnchor, constant: Constants.sectionSpacing),
            submitStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.submitStackButtonHorizontalInset),
            submitStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Constants.submitStackButtonHorizontalInset),

            infoStack.topAnchor.constraint(equalTo: submitStack.bottomAnchor, constant: Constants.infoTopSpacing),
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

    private func setupDelegate() {
        infoStack.delegate = self
        textFieldsStack.delegate = self
        submitStack.delegate = self
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
        titlesStack.configure(titleText: Constants.signInTitle, subtitleText: Constants.signInSubtitle)
        textFieldsStack.showOnlyLoginAndPassword(toShow: true)
        submitStack.changeSubmitButtonText(text: Constants.signInButtonText)
        infoStack.configure(infoText: Constants.signInInfoPrefix, infoActionText: Constants.signInInfoAction)
        textFieldsStack.clearTextFields()
        submitStack.configureErrorLabel(isHidden: true, errorMessage: "")
        textFieldsStack.changeNormalModeTextFields()
        switchAllFlagsToFalse()
    }

    private func applySignUpMode() {
        titlesStack.configure(titleText: Constants.signUpTitle, subtitleText: Constants.signUpSubtitle)
        textFieldsStack.showOnlyLoginAndPassword(toShow: false)
        submitStack.changeSubmitButtonText(text: Constants.signUpButtonText)
        infoStack.configure(infoText: Constants.signUpInfoPrefix, infoActionText: Constants.signUpInfoAction)
        textFieldsStack.clearTextFields()
        submitStack.configureErrorLabel(isHidden: true, errorMessage: "")
        textFieldsStack.changeNormalModeTextFields()
        switchAllFlagsToFalse()
    }

    private func switchAllFlagsToFalse() {
        textFieldsStack.switchAllFlagsToFalse()
        enableSubmitButton()
    }

    private func enableSubmitButton() {
        switch currentState {
        case .singIn:
            textFieldsStack.passwordAndEmailTextFieldsValid
            ? (submitStack.submitButtonCurrentState = .enable)
            : (submitStack.submitButtonCurrentState = .disable)
        case .signUp:
            textFieldsStack.allTextFieldsValid
            ? (submitStack.submitButtonCurrentState = .enable)
            : (submitStack.submitButtonCurrentState = .disable)
        }
    }

    private func didTapInfoAction() {
        self.endEditing(true)
        switch currentState {
        case .singIn:
            currentState = .signUp
        case .signUp:
            currentState = .singIn
        }
    }

    @objc private func submit() {
        submitStack.submitButtonCurrentState = .loading
        self.isUserInteractionEnabled = false
        switch currentState {
        case .singIn:
            delegate?.didTapSignIn(
                email: textFieldsStack.emailTextFieldText,
                password: textFieldsStack.passwordTextFieldText
            )
        case .signUp:
            delegate?.didTapSignUp(
                firstName: textFieldsStack.firstNameTextFieldText,
                lastName: textFieldsStack.lastNameTextFieldText,
                email: textFieldsStack.emailTextFieldText,
                password: textFieldsStack.passwordTextFieldText
            )
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

// MARK: - InfoStackDelegate

extension AuthView: InfoStackDelegate {
    func didTapInfoActionLabel() {
        didTapInfoAction()
    }
}

// MARK: - TextFieldsStackDelegate

extension AuthView: TextFieldsStackDelegate {
    func firstNameTextFieldValidate(text: String?) {
        delegate?.firstNameTextFieldValidate(text: text)
    }

    func lastNameTextFieldValidate(text: String?) {
        delegate?.lastNameTextFieldValidate(text: text)
    }
    
    func emailTextFieldValidate(text: String?) {
        delegate?.emailTextFieldValidate(text: text)
    }
    
    func passwordTextFieldValidate(text: String?) {
        delegate?.passwordTextFieldValidate(text: text)
    }
    
    func sumbit() {
        guard submitStack.submitButtonCurrentState != .enable else { return }
        submit()
    }
}

// MARK: - SubmitStackDelegate

extension AuthView: SubmitStackDelegate {
    func didTapSubmitButton() {
        submit()
    }
}

// MARK: - Constants

private extension AuthView {
    enum Constants {
        static let titlesHorizontalInset: CGFloat = 30
        static let textFieldsHorizontalInset: CGFloat = 20
        static let submitStackButtonHorizontalInset: CGFloat = 40
        static let infoHorizontalInset: CGFloat = 20

        static let sectionSpacing: CGFloat = 50
        static let infoTopSpacing: CGFloat = 10
        static let containerBottomInset: CGFloat = 20

        static let scrollViewTopInset: CGFloat = 50

        static let signInInfoPrefix: String = "У вас нету аккаунта?"
        static let signInInfoAction: String = "Зарегистрируйтесь"

        static let signUpInfoPrefix: String = "У вас есть аккаунт?"
        static let signUpInfoAction: String = "Войдите"

        static let signInTitle: String = "С возвращением!"
        static let signInSubtitle: String = "Введите данные, под которыми вы регистрировались ранее."
        static let signInButtonText: String = "Войти"

        static let signUpTitle: String = "Добро пожаловать!"
        static let signUpSubtitle: String = "Введите данные, чтобы зарегистрироваться."
        static let signUpButtonText: String = "Зарегистрироваться"
    }
}
