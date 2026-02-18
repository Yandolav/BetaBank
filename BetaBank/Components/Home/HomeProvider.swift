import Foundation

protocol HomeProviderProtocol {
    func loadUser(userId: UUID) -> Result<User, Error>
    func loadCards(userId: UUID) -> Result<[Card], Error>
    func loadTransactions(userId: UUID) -> Result<[Transaction], Error>
}

final class HomeProvider {

    // MARK: Private properties

    private let userService: UserServiceProtocol
    private let cardService: CardServiceProtocol
    private let transactionService: TransactionServiceProtocol

    // MARK: Init

    init(userService: UserServiceProtocol, cardService: CardServiceProtocol, transactionService: TransactionServiceProtocol) {
        self.userService = userService
        self.cardService = cardService
        self.transactionService = transactionService
    }
}

// MARK: - HomeProviderProtocol

extension HomeProvider: HomeProviderProtocol {
    func loadUser(userId: UUID) -> Result<User, Error> {
        .success(User(
            id: UUID(),
            firstName: "",
            lastName: "",
            email: "",
            password: "",
            phone: "",
            dataImage: Data()
        ))
    }
    
    func loadCards(userId: UUID) -> Result<[Card], Error> {
        .success([])
    }
    
    func loadTransactions(userId: UUID) -> Result<[Transaction], Error> {
        .success([])
    }
}
