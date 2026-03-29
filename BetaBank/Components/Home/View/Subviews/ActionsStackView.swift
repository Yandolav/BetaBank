import UIKit

final class ActionsStackView: UIView {

    // MARK: Public properties

    var onSendTap: (() -> Void)?
    var onAddCardTap: (() -> Void)?

    // MARK: Private properties

    private let sendButton: ActionButton = {
        let button = ActionButton(icon: DS.Icons.send, title: "Отправить")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let addCardButton: ActionButton = {
        let button = ActionButton(icon: DS.Icons.add, title: "Добавить карту")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [sendButton, addCardButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = DS.Spacing.m
        stack.distribution = .fillEqually
        return stack
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

    // MARK: Private methods

    private func setupView() {
        addSubview(stack)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        addCardButton.addTarget(self, action: #selector(addCardTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc private func sendTapped() {
        onSendTap?()
    }

    @objc private func addCardTapped() {
        onAddCardTap?()
    }
}
