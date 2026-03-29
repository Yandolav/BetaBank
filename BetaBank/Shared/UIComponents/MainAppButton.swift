import UIKit

class MainAppButton: UIControl {

    // MARK: Public properties

    var currentState: MainAppButtonState = .enable {
        didSet {
            changeState()
        }
    }

    // MARK: Private properties

    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.lightBody)
        label.textAlignment = .center
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

    // MARK: Public methods

    func changeText(text: String) {
        title.text = text
    }

    // MARK: Private methods

    private func setupView() {
        self.backgroundColor = DS.Colors.accentColor
        self.isEnabled = true
        self.layer.cornerRadius = DS.Radius.m
        self.addSubview(title)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: DS.Spacing.sm),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.sm),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.sm),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DS.Spacing.sm)
        ])
    }

    private func changeState() {
        layer.removeAllAnimations()

        switch currentState {
        case .enable:
            self.backgroundColor = DS.Colors.accentColor
            self.isEnabled = true
        case .disable:
            self.backgroundColor = DS.Colors.unavailableColor
            self.isEnabled = false
        case .loading:
            self.isEnabled = false
            UIView.animate(
                withDuration: Constants.loadingAnimationDuration,
                delay: Constants.loadingAnimationDelay,
                options: [.repeat, .autoreverse]
            ) {
                self.alpha = Constants.loadingAlpha
            } completion: { _ in
                self.alpha = Constants.defaultAlpha
            }
        }
    }
}

// MARK: - MainAppButtonState

extension MainAppButton {
    enum MainAppButtonState {
        case enable
        case disable
        case loading
    }
}

// MARK: - Constants

private extension MainAppButton {
    enum Constants {
        static let loadingAnimationDuration: TimeInterval = 2
        static let loadingAnimationDelay: TimeInterval = 0
        static let loadingAlpha: CGFloat = 0.5
        static let defaultAlpha: CGFloat = 1
    }
}
