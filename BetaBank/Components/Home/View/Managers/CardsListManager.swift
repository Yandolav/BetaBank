import UIKit

protocol CardsListManagerDelegate: AnyObject {
    func didSelectCard(_ cardId: UUID)
}

final class CardsListManager: NSObject {

    // MARK: Public properties

    weak var delegate: CardsListManagerDelegate?

    // MARK: Private properties

    private weak var collectionView: UICollectionView?
    private var items: [CardCellViewModel] = []

    // MARK: Public methods

    func bind(to collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.collectionViewLayout = makeLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            CardCollectionCell.self,
            forCellWithReuseIdentifier: CardCollectionCell.reuseID
        )
    }

    func setItems(_ items: [CardCellViewModel]) {
        self.items = items
        collectionView?.reloadData()
    }

    // MARK: Private methods

    private func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: Constants.cardWidth, height: Constants.cardHeight)
        layout.minimumLineSpacing = Constants.cardSpacing
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: Constants.sectionHorizontalInset,
            bottom: 0,
            right: Constants.sectionHorizontalInset
        )
        return layout
    }
}

// MARK: - UICollectionViewDataSource

extension CardsListManager: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CardCollectionCell.reuseID,
            for: indexPath
        ) as? CardCollectionCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: items[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CardsListManager: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCard(items[indexPath.item].id)
    }
}

// MARK: - Constants

private extension CardsListManager {
    enum Constants {
        static let cardWidth: CGFloat = 300
        static let cardHeight: CGFloat = 175
        static let cardSpacing: CGFloat = 16
        static let sectionHorizontalInset: CGFloat = 20
    }
}
