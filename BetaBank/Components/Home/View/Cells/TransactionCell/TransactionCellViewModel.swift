import Foundation
import UIKit

struct TransactionCellViewModel: Hashable {
    let id: UUID
    let date: String
    let sectionDate: String
    let amount: String
    let direction: Transaction.Direction
    let status: Transaction.Status
    let comment: String
}

final class TransactionCollectionCell: UICollectionViewCell {

    static let reuseID = "TransactionCollectionCell"

    // MARK: Private properties

    private let iconContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.iconContainerCornerRadius
        view.clipsToBounds = true
        return view
    }()

    private let iconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.iconFontSize, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.commentFontSize, weight: .medium)
        label.textColor = Theme.Colors.blackText
        label.numberOfLines = 1
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.dateFontSize, weight: .regular)
        label.textColor = Theme.Colors.defaultTextColor
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.amountFontSize, weight: .semibold)
        label.textAlignment = .right
        return label
    }()

    private let statusDot: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.statusDotCornerRadius
        return view
    }()

    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.Colors.defaultBorderColor.withAlphaComponent(Constants.separatorAlpha)
        return view
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

    // MARK: Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        commentLabel.text = nil
        dateLabel.text = nil
        amountLabel.text = nil
        iconLabel.text = nil
        iconContainer.backgroundColor = nil
        amountLabel.textColor = nil
        statusDot.backgroundColor = nil
    }

    // MARK: Public methods

    func configure(with viewModel: TransactionCellViewModel) {
        commentLabel.text = viewModel.comment
        dateLabel.text = viewModel.date
        amountLabel.text = viewModel.amount

        switch viewModel.direction {
        case .credit:
            amountLabel.textColor = Theme.Colors.successColor
            iconContainer.backgroundColor = Theme.Colors.successColor.withAlphaComponent(Constants.iconBackgroundAlpha)
            iconLabel.text = Constants.creditIcon
            iconLabel.textColor = Theme.Colors.successColor
        case .debit:
            amountLabel.textColor = Theme.Colors.errorColor
            iconContainer.backgroundColor = Theme.Colors.errorColor.withAlphaComponent(Constants.iconBackgroundAlpha)
            iconLabel.text = Constants.debitIcon
            iconLabel.textColor = Theme.Colors.errorColor
        }

        switch viewModel.status {
        case .success:
            statusDot.backgroundColor = Theme.Colors.successColor
        case .failed:
            statusDot.backgroundColor = Theme.Colors.errorColor
        }
    }

    // MARK: Private methods

    private func setupView() {
        backgroundColor = .white

        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(statusDot)
        contentView.addSubview(amountLabel)
        contentView.addSubview(separatorLine)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            iconContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: Constants.iconContainerSize),
            iconContainer.heightAnchor.constraint(equalToConstant: Constants.iconContainerSize),

            iconLabel.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),

            commentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalInset),
            commentLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: Constants.iconToTextSpacing),
            commentLabel.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: -Constants.textToAmountSpacing),

            dateLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: Constants.commentToDateSpacing),
            dateLabel.leadingAnchor.constraint(equalTo: commentLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalInset),

            statusDot.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            statusDot.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: Constants.statusDotSpacing),
            statusDot.widthAnchor.constraint(equalToConstant: Constants.statusDotSize),
            statusDot.heightAnchor.constraint(equalToConstant: Constants.statusDotSize),

            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            amountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.amountMinWidth),

            separatorLine.heightAnchor.constraint(equalToConstant: Constants.separatorHeight),
            separatorLine.leadingAnchor.constraint(equalTo: commentLabel.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - Constants

private extension TransactionCollectionCell {
    enum Constants {
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 14
        static let iconToTextSpacing: CGFloat = 12
        static let textToAmountSpacing: CGFloat = 8
        static let commentToDateSpacing: CGFloat = 4
        static let statusDotSpacing: CGFloat = 6

        static let iconContainerSize: CGFloat = 44
        static let iconContainerCornerRadius: CGFloat = 22

        static let iconFontSize: CGFloat = 18
        static let creditIcon: String = "↓"
        static let debitIcon: String = "↑"

        static let commentFontSize: CGFloat = 15
        static let dateFontSize: CGFloat = 12
        static let amountFontSize: CGFloat = 15
        static let amountMinWidth: CGFloat = 80

        static let statusDotSize: CGFloat = 6
        static let statusDotCornerRadius: CGFloat = 3

        static let separatorHeight: CGFloat = 0.5
        static let separatorAlpha: CGFloat = 0.35

        static let iconBackgroundAlpha: CGFloat = 0.12
    }
}
