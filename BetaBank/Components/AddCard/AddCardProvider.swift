import Foundation

protocol AddCardProviderProtocol: AnyObject {
    func createCard(userId: UUID, fullName: String, bankName: String) -> Result<Void, Error>
}

final class AddCardProvider {

    // MARK: Private properties

    private let cardService: CardServiceProtocol

    // MARK: Init

    init(cardService: CardServiceProtocol) {
        self.cardService = cardService
    }
}

// MARK: - AddCardProviderProtocol

extension AddCardProvider: AddCardProviderProtocol {
    func createCard(userId: UUID, fullName: String, bankName: String) -> Result<Void, Error> {
        .success(())
    }
}
