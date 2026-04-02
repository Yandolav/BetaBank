import UIKit

final class TransactionSectionHeaderView: UICollectionReusableView {

    static let reuseID = "TransactionSectionHeaderView"

    // MARK: Private properties

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.caption)
        return label
    }()

    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = DS.Colors.defaultBorderColor.withAlphaComponent(Constants.separatorAlpha)
        return view
    }()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = DS.Colors.surfaceColor
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    func configure(date: String) {
        dateLabel.text = date
    }

    // MARK: Private methods

    private func setupView() {
        addSubview(dateLabel)
        addSubview(separatorLine)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.m),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.m),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: Constants.separatorHeight),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Constants

private extension TransactionSectionHeaderView {
    enum Constants {
        static let separatorHeight: CGFloat = 0.5
        static let separatorAlpha: CGFloat = 0.4
    }
}
