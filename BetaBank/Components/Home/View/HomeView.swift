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
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        return cv
    }()

    // MARK: Private properties

    private let headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        label.textColor = Theme.Colors.blackText
        return label
    }()

    private let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: Constants.profileIconSize, weight: .medium)
        button.setImage(UIImage(systemName: "person.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = Theme.Colors.accentColor
        return button
    }()

    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.Colors.unavailableСolor
        button.layer.cornerRadius = Constants.actionButtonCornerRadius
        button.tintColor = Theme.Colors.accentColor
        let config = UIImage.SymbolConfiguration(pointSize: Constants.actionIconSize, weight: .semibold)
        button.setImage(UIImage(systemName: "arrow.up.right", withConfiguration: config), for: .normal)
        button.setTitle("  Отправить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.actionFontSize, weight: .semibold)
        return button
    }()

    private let receiveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.Colors.unavailableСolor
        button.layer.cornerRadius = Constants.actionButtonCornerRadius
        button.tintColor = Theme.Colors.accentColor
        let config = UIImage.SymbolConfiguration(pointSize: Constants.actionIconSize, weight: .semibold)
        button.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        button.setTitle("  Добавить карту", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.actionFontSize, weight: .semibold)
        return button
    }()

    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.placeholder = "Поиск транзакций"
        bar.backgroundImage = UIImage()
        bar.searchTextField.backgroundColor = Theme.Colors.unavailableСolor
        bar.searchTextField.font = UIFont.systemFont(ofSize: Constants.searchFontSize)
        bar.searchTextField.textColor = Theme.Colors.blackText
        bar.tintColor = Theme.Colors.accentColor
        return bar
    }()

    private lazy var actionsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [sendButton, receiveButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constants.actionsStackSpacing
        stack.distribution = .fillEqually
        return stack
    }()

    private let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.tintColor = Theme.Colors.accentColor
        return rc
    }()

    private let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = Theme.Colors.accentColor
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private let emptyImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: Constants.stateIconSize, weight: .light)
        iv.image = UIImage(systemName: "tray", withConfiguration: config)
        iv.tintColor = Theme.Colors.defaultBorderColor
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Нет данных"
        label.font = UIFont.systemFont(ofSize: Constants.stateLabelFontSize, weight: .regular)
        label.textColor = Theme.Colors.defaultTextColor
        label.textAlignment = .center
        return label
    }()

    private let errorStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private let errorImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: Constants.stateIconSize, weight: .light)
        iv.image = UIImage(systemName: "wifi.exclamationmark", withConfiguration: config)
        iv.tintColor = Theme.Colors.defaultBorderColor
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.stateLabelFontSize, weight: .regular)
        label.textColor = Theme.Colors.defaultTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Повторить", for: .normal)
        button.tintColor = Theme.Colors.whiteText
        button.backgroundColor = Theme.Colors.accentColor
        button.layer.cornerRadius = Constants.actionButtonCornerRadius
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.actionFontSize, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(
            top: Constants.retryButtonVerticalInset,
            left: Constants.retryButtonHorizontalInset,
            bottom: Constants.retryButtonVerticalInset,
            right: Constants.retryButtonHorizontalInset
        )
        return button
    }()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    func configure(bankName: String) {
        titleLabel.text = bankName
    }

    func setState(_ state: Home.ViewControllerState) {
        switch state {
        case .loading:
            loadingView.startAnimating()
            setContentVisible(false)
            profileButton.isHidden = true
            emptyStateView.isHidden = true
            errorStateView.isHidden = true

        case .content:
            loadingView.stopAnimating()
            setContentVisible(true)
            profileButton.isHidden = false
            emptyStateView.isHidden = true
            errorStateView.isHidden = true
            refreshControl.endRefreshing()

        case .empty:
            loadingView.stopAnimating()
            setContentVisible(false)
            profileButton.isHidden = true
            emptyStateView.isHidden = false
            errorStateView.isHidden = true
            refreshControl.endRefreshing()

        case .error(let message):
            loadingView.stopAnimating()
            setContentVisible(false)
            profileButton.isHidden = true
            emptyStateView.isHidden = true
            errorStateView.isHidden = false
            errorLabel.text = message
            refreshControl.endRefreshing()
        }
    }

    // MARK: Private methods

    private func setupView() {
        backgroundColor = .white
        searchBar.delegate = self
        transactionsCollectionView.refreshControl = refreshControl

        headerContainerView.addSubview(titleLabel)
        headerContainerView.addSubview(profileButton)
        headerContainerView.addSubview(cardsCollectionView)
        headerContainerView.addSubview(actionsStack)
        headerContainerView.addSubview(searchBar)

        addSubview(headerContainerView)
        addSubview(transactionsCollectionView)
        addSubview(loadingView)

        emptyStateView.addSubview(emptyImageView)
        emptyStateView.addSubview(emptyLabel)
        addSubview(emptyStateView)

        errorStateView.addSubview(errorImageView)
        errorStateView.addSubview(errorLabel)
        errorStateView.addSubview(retryButton)
        addSubview(errorStateView)
    }

    private func setupConstraints() {
        let guide = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            headerContainerView.topAnchor.constraint(equalTo: guide.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: Constants.titleTopInset),
            titleLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: Constants.horizontalInset),
            titleLabel.trailingAnchor.constraint(equalTo: profileButton.leadingAnchor, constant: -Constants.titleToProfileSpacing),

            profileButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            profileButton.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -Constants.horizontalInset),
            profileButton.widthAnchor.constraint(equalToConstant: Constants.profileButtonSize),
            profileButton.heightAnchor.constraint(equalToConstant: Constants.profileButtonSize),

            cardsCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.cardTopSpacing),
            cardsCollectionView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            cardsCollectionView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            cardsCollectionView.heightAnchor.constraint(equalToConstant: Constants.cardHeight),

            actionsStack.topAnchor.constraint(equalTo: cardsCollectionView.bottomAnchor, constant: Constants.actionsTopSpacing),
            actionsStack.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: Constants.horizontalInset),
            actionsStack.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -Constants.horizontalInset),
            actionsStack.heightAnchor.constraint(equalToConstant: Constants.actionsHeight),

            searchBar.topAnchor.constraint(equalTo: actionsStack.bottomAnchor, constant: Constants.searchTopSpacing),
            searchBar.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: Constants.searchHorizontalInset),
            searchBar.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -Constants.searchHorizontalInset),
            searchBar.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -Constants.searchBottomInset),

            transactionsCollectionView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            transactionsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            transactionsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            transactionsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),

            emptyStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: centerYAnchor),

            emptyImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: Constants.stateIconViewSize),
            emptyImageView.heightAnchor.constraint(equalToConstant: Constants.stateIconViewSize),

            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: Constants.stateIconToLabelSpacing),
            emptyLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            emptyLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor),

            errorStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorStateView.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorStateView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.errorStateHorizontalInset),
            errorStateView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.errorStateHorizontalInset),

            errorImageView.topAnchor.constraint(equalTo: errorStateView.topAnchor),
            errorImageView.centerXAnchor.constraint(equalTo: errorStateView.centerXAnchor),
            errorImageView.widthAnchor.constraint(equalToConstant: Constants.stateIconViewSize),
            errorImageView.heightAnchor.constraint(equalToConstant: Constants.stateIconViewSize),

            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: Constants.stateIconToLabelSpacing),
            errorLabel.leadingAnchor.constraint(equalTo: errorStateView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: errorStateView.trailingAnchor),

            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: Constants.retryTopSpacing),
            retryButton.centerXAnchor.constraint(equalTo: errorStateView.centerXAnchor),
            retryButton.bottomAnchor.constraint(equalTo: errorStateView.bottomAnchor)
        ])
    }

    private func setContentVisible(_ visible: Bool) {
        cardsCollectionView.isHidden = !visible
        actionsStack.isHidden = !visible
        searchBar.isHidden = !visible
        transactionsCollectionView.isHidden = !visible
    }

    private func setupTargets() {
        profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        receiveButton.addTarget(self, action: #selector(receiveTapped), for: .touchUpInside)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }

    // MARK: Actions

    @objc private func profileTapped() {
        delegate?.didTapProfile()
    }

    @objc private func sendTapped() {
        delegate?.didTapSend()
    }

    @objc private func receiveTapped() {
        delegate?.didTapAddCard()
    }

    @objc private func retryTapped() {
        delegate?.didTapRetry()
    }

    @objc private func handleRefresh() {
        delegate?.didRefresh()
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
        static let titleFontSize: CGFloat = 28
        static let actionFontSize: CGFloat = 15
        static let searchFontSize: CGFloat = 14
        static let stateLabelFontSize: CGFloat = 16

        static let profileIconSize: CGFloat = 22
        static let actionIconSize: CGFloat = 13
        static let stateIconSize: CGFloat = 48
        static let stateIconViewSize: CGFloat = 60

        static let profileButtonSize: CGFloat = 36
        static let actionButtonCornerRadius: CGFloat = 14
        static let retryButtonVerticalInset: CGFloat = 12
        static let retryButtonHorizontalInset: CGFloat = 32

        static let horizontalInset: CGFloat = 20
        static let titleTopInset: CGFloat = 16
        static let titleToProfileSpacing: CGFloat = 12
        static let cardTopSpacing: CGFloat = 20
        static let cardHeight: CGFloat = 175
        static let actionsTopSpacing: CGFloat = 20
        static let actionsHeight: CGFloat = 50
        static let actionsStackSpacing: CGFloat = 12
        static let searchTopSpacing: CGFloat = 8
        static let searchHorizontalInset: CGFloat = 8
        static let searchBottomInset: CGFloat = 4

        static let stateIconToLabelSpacing: CGFloat = 12
        static let errorStateHorizontalInset: CGFloat = 40
        static let retryTopSpacing: CGFloat = 20
    }
}
