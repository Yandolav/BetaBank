final class DependencyContainer {

    // MARK: Private properties

    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol
    private let cardService: CardServiceProtocol
    private let transactionService: TransactionServiceProtocol

    // MARK: Init

    init() {
        let store = FileDataStore()

        let userStorage = UserStorage(store: store)
        let cardStorage = CardStorage(store: store)
        let transactionStorage = TransactionStorage(store: store)

        self.authService = AuthService(storage: userStorage)
        self.userService = UserService(userStorage: userStorage)
        self.cardService = CardService(cardStorage: cardStorage)
        self.transactionService = TransactionService(transactionStorage: transactionStorage)
    }

    // MARK: Public methods

    func getAuthService() -> AuthServiceProtocol {
        authService
    }

    func getUserService() -> UserServiceProtocol {
        userService
    }

    func getCardService() -> CardServiceProtocol {
        cardService
    }

    func getTransactionService() -> TransactionServiceProtocol {
        transactionService
    }
}
