import UIKit

protocol HomeViewDelegate: AnyObject {
    func didTapOnProfile()
    func didSelectCard(_ cardId: UUID)
    func didSelectTransaction(_ transactionId: UUID)
    func didTapTransfer(fromCardId: UUID)
    func didTapOnAddScreen()
}

final class HomeView: UIView {

    // MARK: Public properties

    weak var delegate: HomeViewDelegate?

    // MARK: Private properties

    private let mokLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Fonts.body
        label.textColor = Theme.Colors.blackText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public properties

    func configure(id: UUID) {
        mokLabel.text = "Главный экрна. UUID: \(id)"
    }

    // MARK: Private func

    private func setupView() {
        self.backgroundColor = .white

        self.addSubview(mokLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mokLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mokLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            mokLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mokLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
