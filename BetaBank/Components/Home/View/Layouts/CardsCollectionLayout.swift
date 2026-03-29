import UIKit

final class CardsCollectionLayout: UICollectionViewFlowLayout {

    // MARK: Init

    override init() {
        super.init()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func setupLayout() {
        scrollDirection  = .horizontal
        itemSize = CGSize(width: Constants.cardWidth, height: Constants.cardHeight)
        minimumLineSpacing = DS.Spacing.m
        sectionInset = UIEdgeInsets(
            top: 0,
            left: DS.Spacing.l,
            bottom: 0,
            right: DS.Spacing.l
        )
    }
}

// MARK: - Constants

private extension CardsCollectionLayout {
    enum Constants {
        static let cardWidth: CGFloat = 300
        static let cardHeight: CGFloat = 175
    }
}
