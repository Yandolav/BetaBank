import UIKit

protocol HomeViewDelegate: AnyObject {
    func didTapProfile()
    func didTapSend()
    func didTapAddCard()
    func didTapRetry()
    func didRefresh()
    func didChangeSearch(query: String)
}

final class HomeView: UIView {

    // MARK: Public properties

    weak var delegate: HomeViewDelegate?

    let cardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.clipsToBounds = false
        return cv
    }()

    let transactionsCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = DS.Colors.background
        cv.showsVerticalScrollIndicator = false
        return cv
    }()

    // MARK: Private properties

    private let headerView: HeaderContainerView = {
        let view = HeaderContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let actionsView: ActionsStackView = {
        let view = ActionsStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.placeholder = "Поиск транзакций"
        bar.backgroundImage = UIImage()
        bar.searchTextField.backgroundColor = DS.Colors.unavailableColor
        bar.searchTextField.font = UIFont.systemFont(ofSize: Constants.searchFontSize)
        bar.searchTextField.textColor = DS.Colors.blackText
        bar.tintColor = DS.Colors.accentColor
        return bar
    }()

    private let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.tintColor = DS.Colors.accentColor
        return rc
    }()

    private let loadingView: DSLoadingView = {
        let view = DSLoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private let emptyView: DSEmptyView = {
        let view = DSEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private let errorView: DSErrorView = {
        let view = DSErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setContentVisible(false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    func configure(bankName: String) {
        headerView.configure(bankName: bankName)
    }

    func setState(_ state: Home.ViewControllerState) {
        switch state {
        case .loading:
            setContentVisible(false)
            headerView.isProfileHidden = true
            loadingView.configure(with: .init())
            loadingView.show()
            emptyView.isHidden = true
            errorView.isHidden = true

        case .content:
            setContentVisible(true)
            headerView.isProfileHidden = false
            loadingView.hide()
            emptyView.isHidden = true
            errorView.isHidden = true
            refreshControl.endRefreshing()

        case .empty:
            setContentVisible(false)
            headerView.isProfileHidden = true
            loadingView.hide()
            emptyView.configure(with: .init())
            emptyView.isHidden = false
            errorView.isHidden = true
            refreshControl.endRefreshing()

        case .error(let message):
            setContentVisible(false)
            headerView.isProfileHidden = true
            loadingView.hide()
            emptyView.isHidden = true
            errorView.configure(
                with: .init(
                    message: message,
                    onRetry: { [weak self] in self?.delegate?.didTapRetry() }
                )
            )
            errorView.isHidden = false
            refreshControl.endRefreshing()
        }
    }

    // MARK: Private methods

    private func setupView() {
        backgroundColor = DS.Colors.background
        searchBar.delegate = self
        transactionsCollectionView.refreshControl = refreshControl

        headerView.onProfileTap = { [weak self] in self?.delegate?.didTapProfile() }
        actionsView.configure(
            with: .init(
                onSendTap: { [weak self] in self?.delegate?.didTapSend() },
                onAddCardTap: { [weak self] in self?.delegate?.didTapAddCard() }
            )
        )

        addSubview(headerView)
        addSubview(cardsCollectionView)
        addSubview(actionsView)
        addSubview(searchBar)
        addSubview(transactionsCollectionView)
        addSubview(loadingView)
        addSubview(emptyView)
        addSubview(errorView)
    }

    private func setupConstraints() {
        let guide = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: guide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            cardsCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: DS.Spacing.s),
            cardsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardsCollectionView.heightAnchor.constraint(equalToConstant: Constants.cardHeight),

            actionsView.topAnchor.constraint(equalTo: cardsCollectionView.bottomAnchor, constant: DS.Spacing.l),
            actionsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.l),
            actionsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.l),
            actionsView.heightAnchor.constraint(equalToConstant: Constants.actionsHeight),

            searchBar.topAnchor.constraint(equalTo: actionsView.bottomAnchor, constant: DS.Spacing.s),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.s),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.s),

            transactionsCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: DS.Spacing.xs),
            transactionsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            transactionsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            transactionsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.xxl),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.xxl),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),

            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.xxl),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.xxl),
            emptyView.centerYAnchor.constraint(equalTo: centerYAnchor),

            errorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.xxl),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.xxl),
            errorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setContentVisible(_ visible: Bool) {
        cardsCollectionView.isHidden = !visible
        actionsView.isHidden = !visible
        searchBar.isHidden = !visible
        transactionsCollectionView.isHidden = !visible
    }
}

// MARK: - UISearchBarDelegate

extension HomeView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.didChangeSearch(query: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Constants

private extension HomeView {
    enum Constants {
        static let searchFontSize: CGFloat = 14
        static let cardHeight: CGFloat = 175
        static let actionsHeight: CGFloat = 50
    }
}
