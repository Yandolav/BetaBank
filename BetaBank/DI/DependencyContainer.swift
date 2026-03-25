import Foundation
final class DependencyContainer {

    // MARK: Private properties

    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol
    private let cardService: CardServiceProtocol
    private let transactionService: TransactionServiceProtocol

    // MARK: Init

    init() {
        let store = FileDataStore()
        let networkClient = NetworkClient()
        let validator = ValidationWorker()

        let userStorage = UserStorage(store: store)
        let cardStorage = CardStorage(store: store)
        let transactionStorage = TransactionStorage(store: store)

        let userNetworkService = UserNetworkService(client: networkClient, storage: userStorage)
        let cardNetworkService = CardNetworkService(client: networkClient, storage: cardStorage)
        let transactionNetworkService = TransactionNetworkService(client: networkClient, storage: transactionStorage)

        self.authService = AuthService(networkService: userNetworkService, validator: validator)
        self.userService = UserService(networkService: userNetworkService, validator: validator)
        self.cardService = CardService(networkService: cardNetworkService)
        self.transactionService = TransactionService(
            networkService: transactionNetworkService,
            cardNetworkService: cardNetworkService
        )
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
