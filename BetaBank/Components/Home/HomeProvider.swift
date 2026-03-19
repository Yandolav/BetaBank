import Foundation

protocol HomeProviderProtocol {
    func loadUser(userId: UUID) async -> Result<User, Error>
    func loadCards(userId: UUID) async -> Result<[Card], Error>
    func loadTransactions(userId: UUID) async -> Result<[Transaction], Error>
}

final class HomeProvider {

    // MARK: Private properties

    private let userService: UserServiceProtocol
    private let cardService: CardServiceProtocol
    private let transactionService: TransactionServiceProtocol

    // MARK: Init

    init(
        userService: UserServiceProtocol,
        cardService: CardServiceProtocol,
        transactionService: TransactionServiceProtocol
    ) {
        self.userService = userService
        self.cardService = cardService
        self.transactionService = transactionService
    }
}

// MARK: - HomeProviderProtocol

extension HomeProvider: HomeProviderProtocol {

    func loadUser(userId: UUID) async -> Result<User, Error> {
        await userService.getUser(userId: userId)
    }

    func loadCards(userId: UUID) async -> Result<[Card], Error> {
        await cardService.getAllCards(userId: userId)
    }

    func loadTransactions(userId: UUID) async -> Result<[Transaction], Error> {
        await transactionService.getAllTransactions(userId: userId)
    }
}
