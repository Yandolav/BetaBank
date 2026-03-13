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
        label.textColor = Theme.Colors.whiteText
        label.font = Theme.Fonts.body
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
        self.backgroundColor = Theme.Colors.accentColor
        self.isEnabled = true
        self.layer.cornerRadius = Constants.cornerRadius
        self.addSubview(title)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: Constants.titleTopInset),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.titleHorizontalInset),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.titleHorizontalInset),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.titleBottomInset)
        ])
    }

    private func changeState() {
        layer.removeAllAnimations()

        switch currentState {
        case .enable:
            self.backgroundColor = Theme.Colors.accentColor
            self.isEnabled = true
        case .disable:
            self.backgroundColor = Theme.Colors.unavailableСolor
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
        static let cornerRadius: CGFloat = 15

        static let titleTopInset: CGFloat = 10
        static let titleBottomInset: CGFloat = 10
        static let titleHorizontalInset: CGFloat = 10

        static let loadingAnimationDuration: TimeInterval = 2
        static let loadingAnimationDelay: TimeInterval = 0
        static let loadingAlpha: CGFloat = 0.5
        static let defaultAlpha: CGFloat = 1
    }
}
