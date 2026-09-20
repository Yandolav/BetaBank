import UIKit

struct ActionsStackViewModel {
    let onSendTap: () -> Void
    let onAddCardTap: () -> Void
}

final class ActionsStackView: UIView {

    // MARK: Private properties

    private var onSendTap: (() -> Void)?
    private var onAddCardTap: (() -> Void)?

    private let sendButton: DSActionButton = {
        let button = DSActionButton(style: .tinted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(with: .init(icon: DS.Icons.send, title: "Отправить"))
        return button
    }()

    private let addCardButton: DSActionButton = {
        let button = DSActionButton(style: .tinted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(with: .init(icon: DS.Icons.add, title: "Добавить карту"))
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

    // MARK: Public methods

    func configure(with viewModel: ActionsStackViewModel) {
        onSendTap = viewModel.onSendTap
        onAddCardTap = viewModel.onAddCardTap
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
