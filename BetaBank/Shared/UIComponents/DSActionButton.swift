import UIKit

struct DSActionButtonViewModel {
    let icon: UIImage?
    let title: String
}

final class DSActionButton: UIButton {

    enum Style {
        case tinted
        case filled
    }

    // MARK: Private properties

    private let style: Style

    // MARK: Init

    init(style: Style = .tinted) {
        self.style = style
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    func configure(with viewModel: DSActionButtonViewModel) {
        setImage(viewModel.icon, for: .normal)
        setTitle("\(viewModel.title)", for: .normal)
    }

    // MARK: Private methods

    private func setupView() {
        layer.cornerRadius = DS.Radius.m
        titleLabel?.font = DS.Fonts.bodyMedium

        switch style {
        case .tinted:
            backgroundColor = DS.Colors.surfaceColor
            tintColor = DS.Colors.accentInteractive
            setTitleColor(DS.Colors.accentInteractive, for: .normal)
        case .filled:
            backgroundColor = DS.Colors.accentColor
            tintColor = DS.Colors.whiteText
            setTitleColor(DS.Colors.whiteText, for: .normal)
        }
    }
}
