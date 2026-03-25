import UIKit

final class TitlesStack: UIView {

    // MARK: Private properties

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
        label.numberOfLines = Constants.titlesNumberOfLines
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Theme.Fonts.body
        label.textColor = Theme.Colors.defaultTextColor
        label.numberOfLines = Constants.titlesNumberOfLines
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

// MARK: - Constants

private extension TitlesStack {
    enum Constants {
        static let titlesStackSpacing: CGFloat = 10
        static let titlesNumberOfLines: Int = 0
    }
}
