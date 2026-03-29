import UIKit

final class ActionButton: UIButton {

    // MARK: Init

    init(icon: UIImage, title: String) {
        super.init(frame: .zero)
        setupView(icon: icon, title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func setupView(icon: UIImage, title: String) {
        backgroundColor = DS.Colors.surfaceColor
        layer.cornerRadius = DS.Radius.m
        tintColor = DS.Colors.accentInteractive
        titleLabel?.font = DS.Fonts.bodyMedium

        setImage(icon, for: .normal)
        setTitle("  \(title)", for: .normal)
        setTitleColor(DS.Colors.accentInteractive, for: .normal)
    }
}

// MARK: - Constants

private extension ActionButton {
    enum Constants {
        static let iconSize: CGFloat = 13
    }
}
