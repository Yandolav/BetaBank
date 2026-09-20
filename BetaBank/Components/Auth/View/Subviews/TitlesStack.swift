import UIKit

final class TitlesStack: UIView {

    // MARK: Private properties

    private let titlesStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = DS.Spacing.sm
        stack.distribution = .equalSpacing
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.title)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.apply(.body)
        label.numberOfLines = 0
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

    func configure(titleText: String, subtitleText: String) {
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText
    }

    // MARK: Private methods

    private func setupView() {
        addSubview(titlesStack)
        titlesStack.addArrangedSubview(titleLabel)
        titlesStack.addArrangedSubview(subtitleLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titlesStack.topAnchor.constraint(equalTo: topAnchor),
            titlesStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            titlesStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            titlesStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
