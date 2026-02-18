import Foundation

protocol CardDetailsProviderProtocol: AnyObject {
    func loadCard(cardId: UUID) -> Result<Card, Error>
}

final class CardDetailsProvider {

    // MARK: Private properties

    private let cardService: CardServiceProtocol

    // MARK: Init

    init(cardService: CardServiceProtocol) {
        self.cardService = cardService
    }
}

// MARK: - CardDetailsProviderProtocol

extension CardDetailsProvider: CardDetailsProviderProtocol {
    func loadCard(cardId: UUID) -> Result<Card, Error> {
        .success(Card(
            id: UUID(),
            userID: UUID(),
            balance: 0,
            number: "",
            userFullName: "",
            validatePeriod: Date(),
            bankName: "",
            code: ""
        ))
    }
}
