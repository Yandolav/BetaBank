import UIKit

struct DSInputTextFieldViewModel {
    let title: String
    let placeholder: String
    let returnKeyType: UIReturnKeyType
    let onReturn: ((DSInputTextField) -> Void)?
    let onTextChange: ((DSInputTextField) -> Void)?

    init(
        title: String,
        placeholder: String,
        returnKeyType: UIReturnKeyType = .next,
        onReturn: ((DSInputTextField) -> Void)? = nil,
        onTextChange: ((DSInputTextField) -> Void)? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self.returnKeyType = returnKeyType
        self.onReturn = onReturn
        self.onTextChange = onTextChange
    }
}

class DSInputTextField: UIView {

    enum Style {
        case plain
        case secure
    }

    var textFieldText: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    private let style: Style
    private var onReturn: ((DSInputTextField) -> Void)?
    private var onTextChange: ((DSInputTextField) -> Void)?

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

    // MARK: Init

    init(style: Style = .plain) {
        self.style = style
        super.init(frame: .zero)
        setupView()
        setupConstraint()
        applyStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    func configure(with viewModel: DSInputTextFieldViewModel) {
        titleLabel.text = viewModel.title

        textField.attributedPlaceholder = NSAttributedString(
            string: viewModel.placeholder,
            attributes: [
                .font: DS.Fonts.body,
                .foregroundColor: DS.Colors.placeholderTextColor
            ]
        )
        textField.returnKeyType = viewModel.returnKeyType

        onReturn = viewModel.onReturn
        onTextChange = viewModel.onTextChange

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
        rightAccessory.addTarget(self, action: #selector(accessoryTapped), for: .touchUpInside)
    }

    private func applyStyle() {
        switch style {
        case .plain:
            textField.isSecureTextEntry = false
            rightAccessory.setImage(DS.Icons.clear, for: .normal)
        case .secure:
            textField.isSecureTextEntry = true
            rightAccessory.setImage(DS.Icons.passwordHidden, for: .normal)
        }
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

    @objc private func accessoryTapped() {
        switch style {
        case .plain:
            textFieldText = ""
            changeState(state: .normal)
        case .secure:
            textField.isSecureTextEntry.toggle()
            let icon = textField.isSecureTextEntry ? DS.Icons.passwordHidden : DS.Icons.passwordVisible
            rightAccessory.setImage(icon, for: .normal)
        }
    }

    @objc private func textDidChange() {
        onTextChange?(self)
    }
}

// MARK: - TextFieldState

extension DSInputTextField {
    enum TextFieldState {
        case normal
        case error(errorMessage: String)
        case success
    }
}

// MARK: - UITextFieldDelegate

extension DSInputTextField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text ?? "").isEmpty {
            changeState(state: .normal)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturn?(self)
        return false
    }
}
