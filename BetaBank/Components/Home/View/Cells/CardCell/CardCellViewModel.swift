import Foundation
import UIKit

struct CardCellViewModel: Equatable {
    let id: UUID
    let holderName: String
    let bankName: String
    let cardNumber: String
    let balance: String
    let validatePeriod: String
}

final class CardCollectionCell: UICollectionViewCell {

    static let reuseID = "CardCollectionCell"

    // MARK: Private properties

    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            DS.Colors.accentColor.cgColor,
            Constants.gradientMidColor.cgColor,
            Constants.gradientEndColor.cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }()

    private let glowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = DS.Colors.whiteText.withAlphaComponent(Constants.glowAlpha)
        view.layer.cornerRadius = Constants.glowCornerRadius
        return view
    }()

    private let holderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.lightTitle2)
        return label
    }()

    private let bankNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.lightCaption)
        return label
    }()

    private let cardNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.lightMonospacedBody)
        return label
    }()

    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.lightTitle)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = Constants.balanceMinScale
        return label
    }()

    private let validateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.apply(.lightMonospacedCaption)
        label.textAlignment = .right
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

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
    }

    // MARK: Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        holderLabel.text = nil
        bankNameLabel.text = nil
        cardNumberLabel.text = nil
        balanceLabel.text = nil
        validateLabel.text = nil
    }

    // MARK: Public methods

    func configure(with viewModel: CardCellViewModel) {
        holderLabel.text = viewModel.holderName
        bankNameLabel.text = viewModel.bankName
        cardNumberLabel.text = viewModel.cardNumber
        balanceLabel.text = viewModel.balance
        validateLabel.text = viewModel.validatePeriod
    }

    // MARK: Private methods

    private func setupView() {
        contentView.layer.cornerRadius = DS.Radius.l
        contentView.clipsToBounds = true
        contentView.layer.insertSublayer(gradientLayer, at: 0)

        contentView.addSubview(glowView)
        contentView.addSubview(holderLabel)
        contentView.addSubview(bankNameLabel)
        contentView.addSubview(cardNumberLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(validateLabel)

        layer.applyShadow(DS.Shadow.card)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            glowView.widthAnchor.constraint(equalToConstant: Constants.glowSize),
            glowView.heightAnchor.constraint(equalToConstant: Constants.glowSize),
            glowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.glowTrailingOffset),
            glowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            holderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Spacing.l),
            holderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),
            holderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),
            bankNameLabel.topAnchor.constraint(equalTo: holderLabel.bottomAnchor, constant: Constants.holderToBankSpacing),
            bankNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),
            bankNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),
            cardNumberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cardNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),
            cardNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),
            balanceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DS.Spacing.l),
            balanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),
            balanceLabel.trailingAnchor.constraint(equalTo: validateLabel.leadingAnchor, constant: -DS.Spacing.s),
            validateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.validateBottomInset),
            validateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),
            validateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.validateMinWidth)
        ])
    }
}

// MARK: - Constants

private extension CardCollectionCell {
    enum Constants {
        static let gradientMidColor = UIColor(red: 0.300, green: 0.200, blue: 0.780, alpha: 1)
        static let gradientEndColor = UIColor(red: 0.213, green: 0.310, blue: 0.850, alpha: 1)

        static let holderToBankSpacing: CGFloat = 4
        static let validateBottomInset: CGFloat = 22

        static let glowSize: CGFloat = 160
        static let glowCornerRadius: CGFloat = 80
        static let glowTrailingOffset: CGFloat = 20
        static let glowAlpha: CGFloat = 0.08

        static let balanceMinScale: CGFloat = 0.7

        static let validateMinWidth: CGFloat = 50
    }
}
