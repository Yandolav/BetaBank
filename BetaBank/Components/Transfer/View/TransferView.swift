import UIKit

protocol TransferViewDelegate: AnyObject {
    func transfer(
        amountMinor: Int,
        comment: String?,
        fromCard: UUID,
        toCard: UUID
    )
}

final class TransferView: UIView {

    weak var delegate: TransferViewDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Transfer"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = Theme.Colors.blackText
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
