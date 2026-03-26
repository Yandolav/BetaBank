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
            Theme.Colors.accentColor.cgColor,
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
        view.backgroundColor = Theme.Colors.whiteText.withAlphaComponent(Constants.glowAlpha)
        view.layer.cornerRadius = Constants.glowCornerRadius
        return view
    }()

    private let holderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.holderFontSize, weight: .semibold)
        label.textColor = Theme.Colors.whiteText
        return label
    }()

    private let bankNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.bankFontSize, weight: .regular)
        label.textColor = Theme.Colors.whiteText.withAlphaComponent(Constants.bankNameAlpha)
        return label
    }()

    private let cardNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.monospacedSystemFont(ofSize: Constants.cardNumberFontSize, weight: .regular)
        label.textColor = Theme.Colors.whiteText.withAlphaComponent(Constants.cardNumberAlpha)
        return label
    }()

    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.balanceFontSize, weight: .bold)
        label.textColor = Theme.Colors.whiteText
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = Constants.balanceMinScale
        return label
    }()

    private let validateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.monospacedSystemFont(ofSize: Constants.validateFontSize, weight: .medium)
        label.textColor = Theme.Colors.whiteText.withAlphaComponent(Constants.validateAlpha)
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
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.clipsToBounds = true
        contentView.layer.insertSublayer(gradientLayer, at: 0)

        contentView.addSubview(glowView)
        contentView.addSubview(holderLabel)
        contentView.addSubview(bankNameLabel)
        contentView.addSubview(cardNumberLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(validateLabel)

        layer.shadowColor = Theme.Colors.accentColor.cgColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowOffset = CGSize(width: Constants.shadowOffsetX, height: Constants.shadowOffsetY)
        layer.shadowRadius = Constants.shadowRadius
        layer.masksToBounds = false
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            glowView.widthAnchor.constraint(equalToConstant: Constants.glowSize),
            glowView.heightAnchor.constraint(equalToConstant: Constants.glowSize),
            glowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.glowTrailingOffset),
            glowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            holderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalInset),
            holderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            holderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            bankNameLabel.topAnchor.constraint(equalTo: holderLabel.bottomAnchor, constant: Constants.holderToBankSpacing),
            bankNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            bankNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            cardNumberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cardNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            cardNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            balanceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalInset),
            balanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            balanceLabel.trailingAnchor.constraint(equalTo: validateLabel.leadingAnchor, constant: -Constants.balanceToValidateSpacing),
            validateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.validateBottomInset),
            validateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            validateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.validateMinWidth)
        ])
    }
}

// MARK: - Constants

private extension CardCollectionCell {
    enum Constants {
        static let gradientMidColor = UIColor(red: 0.300, green: 0.200, blue: 0.780, alpha: 1)
        static let gradientEndColor = UIColor(red: 0.213, green: 0.310, blue: 0.850, alpha: 1)

        static let horizontalInset: CGFloat = 20
        static let verticalInset: CGFloat = 20
        static let holderToBankSpacing: CGFloat = 4
        static let balanceToValidateSpacing: CGFloat = 8
        static let validateBottomInset: CGFloat = 22

        static let cornerRadius: CGFloat = 20
        static let shadowOpacity: Float = 0.4
        static let shadowOffsetX: CGFloat = 0
        static let shadowOffsetY: CGFloat = 10
        static let shadowRadius: CGFloat = 18

        static let glowSize: CGFloat = 160
        static let glowCornerRadius: CGFloat = 80
        static let glowTrailingOffset: CGFloat = 20
        static let glowAlpha: CGFloat = 0.08

        static let holderFontSize: CGFloat = 20
        static let bankFontSize: CGFloat = 13
        static let cardNumberFontSize: CGFloat = 15
        static let balanceFontSize: CGFloat = 22
        static let validateFontSize: CGFloat = 13
        static let balanceMinScale: CGFloat = 0.7

        static let bankNameAlpha: CGFloat = 0.7
        static let cardNumberAlpha: CGFloat = 0.85
        static let validateAlpha: CGFloat = 0.75

        static let validateMinWidth: CGFloat = 50
    }
}
