import UIKit

protocol TransactionsListManagerDelegate: AnyObject {
    func didSelectTransaction(_ transactionId: UUID)
}

final class TransactionsListManager: NSObject {

    // MARK: Public properties

    weak var delegate: TransactionsListManagerDelegate?

    // MARK: Private properties

    private enum TransactionSection: Hashable {
        case group(date: String)
    }

    private enum TransactionItem: Hashable {
        case transaction(TransactionCellViewModel)
    }

    private weak var collectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<TransactionSection, TransactionItem>?
    private var allItems: [TransactionCellViewModel] = []

    // MARK: Public methods

    func bind(to collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.collectionViewLayout = makeLayout()
        collectionView.delegate = self

        collectionView.register(
            TransactionCollectionCell.self,
            forCellWithReuseIdentifier: TransactionCollectionCell.reuseID
        )
        collectionView.register(
            TransactionSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TransactionSectionHeaderView.reuseID
        )

        dataSource = makeDataSource(for: collectionView)
    }

    func setItems(_ items: [TransactionCellViewModel]) {
        allItems = items
        applySnapshot(items: items)
    }

    func filter(by query: String) {
        if query.isEmpty {
            applySnapshot(items: allItems)
        } else {
            let filtered = allItems.filter {
                $0.comment.localizedCaseInsensitiveContains(query)
            }
            applySnapshot(items: filtered)
        }
    }

    // MARK: Private methods

    private func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(Constants.itemFractionalWidth),
                heightDimension: .absolute(Constants.itemEstimatedHeight)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(Constants.itemFractionalWidth),
                heightDimension: .absolute(Constants.itemEstimatedHeight)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(Constants.itemFractionalWidth),
                heightDimension: .absolute(Constants.headerHeight)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]

            return section
        }
    }

    private func makeDataSource(
        for collectionView: UICollectionView
    ) -> UICollectionViewDiffableDataSource<TransactionSection, TransactionItem> {

        let dataSource = UICollectionViewDiffableDataSource<TransactionSection, TransactionItem>(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            guard case .transaction(let vm) = item,
                  let cell = collectionView.dequeueReusableCell(
                      withReuseIdentifier: TransactionCollectionCell.reuseID,
                      for: indexPath
                  ) as? TransactionCollectionCell
            else { return UICollectionViewCell() }

            cell.configure(with: vm)
            return cell
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                      ofKind: kind,
                      withReuseIdentifier: TransactionSectionHeaderView.reuseID,
                      for: indexPath
                  ) as? TransactionSectionHeaderView,
                  let section = dataSource.snapshot().sectionIdentifiers[safe: indexPath.section]
            else { return UICollectionReusableView() }

            if case .group(let date) = section {
                header.configure(date: date)
            }
            return header
        }

        return dataSource
    }

    private func applySnapshot(items: [TransactionCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<TransactionSection, TransactionItem>()

        let grouped = groupByDate(items)
        for (date, transactions) in grouped {
            let section = TransactionSection.group(date: date)
            snapshot.appendSections([section])
            snapshot.appendItems(transactions.map { .transaction($0) }, toSection: section)
        }

        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    private func groupByDate(
        _ items: [TransactionCellViewModel]
    ) -> [(String, [TransactionCellViewModel])] {
        var order: [String] = []
        var dict: [String: [TransactionCellViewModel]] = [:]

        for item in items {
            let key = item.sectionDate
            if dict[key] == nil {
                order.append(key)
                dict[key] = []
            }
            dict[key]?.append(item)
        }

        return order.map { ($0, dict[$0] ?? []) }
    }
}

// MARK: - UICollectionViewDelegate

extension TransactionsListManager: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath),
              case .transaction(let vm) = item
        else { return }
        delegate?.didSelectTransaction(vm.id)
    }
}

// MARK: - Constants

private extension TransactionsListManager {
    enum Constants {
        static let itemFractionalWidth: CGFloat = 1.0
        static let itemEstimatedHeight: CGFloat = 72
        static let headerHeight: CGFloat = 36
    }
}

// MARK: - Array safe subscript

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
