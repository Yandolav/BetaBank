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
        view.layer.cornerRadius = DS.Radius.xl
        view.clipsToBounds = true
        return view
    }()

    private let iconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.title2)
        label.textAlignment = .center
        return label
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.bodyMedium)
        label.numberOfLines = 1
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.caption2)
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.bodySemibold)
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
        view.backgroundColor = DS.Colors.defaultBorderColor.withAlphaComponent(Constants.separatorAlpha)
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
            amountLabel.textColor = DS.Colors.successColor
            iconContainer.backgroundColor = DS.Colors.successColor.withAlphaComponent(Constants.iconBackgroundAlpha)
            iconLabel.text = DS.Icons.creditArrow
            iconLabel.textColor = DS.Colors.successColor
        case .debit:
            amountLabel.textColor = DS.Colors.errorColor
            iconContainer.backgroundColor = DS.Colors.errorColor.withAlphaComponent(Constants.iconBackgroundAlpha)
            iconLabel.text = DS.Icons.debitArrow
            iconLabel.textColor = DS.Colors.errorColor
        }

        switch viewModel.status {
        case .success:
            statusDot.backgroundColor = DS.Colors.successColor
        case .failed:
            statusDot.backgroundColor = DS.Colors.errorColor
        }
    }

    // MARK: Private methods

    private func setupView() {
        backgroundColor = DS.Colors.background

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
            iconContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.m),
            iconContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: Constants.iconContainerSize),
            iconContainer.heightAnchor.constraint(equalToConstant: Constants.iconContainerSize),

            iconLabel.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),

            commentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalInset),
            commentLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: Constants.iconToTextSpacing),
            commentLabel.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: -DS.Spacing.s),

            dateLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: Constants.commentToDateSpacing),
            dateLabel.leadingAnchor.constraint(equalTo: commentLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalInset),

            statusDot.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            statusDot.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: Constants.statusDotSpacing),
            statusDot.widthAnchor.constraint(equalToConstant: Constants.statusDotSize),
            statusDot.heightAnchor.constraint(equalToConstant: Constants.statusDotSize),

            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.m),
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
        static let verticalInset: CGFloat = 14
        static let iconToTextSpacing: CGFloat = 12
        static let commentToDateSpacing: CGFloat = 4
        static let statusDotSpacing: CGFloat = 6

        static let iconContainerSize: CGFloat = 44

        static let amountMinWidth: CGFloat = 80

        static let statusDotSize: CGFloat = 6
        static let statusDotCornerRadius: CGFloat = 3

        static let separatorHeight: CGFloat = 0.5
        static let separatorAlpha: CGFloat = 0.35

        static let iconBackgroundAlpha: CGFloat = 0.12
    }
}
