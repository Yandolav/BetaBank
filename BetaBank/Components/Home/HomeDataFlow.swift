import Foundation

enum Home {
    enum LoadData {
        struct Request {
            let userId: UUID
        }

        struct Response {
            let result: Result<Payload, Error>
        }

        struct ViewModel {
            let state: ViewControllerState
        }

        struct Payload {
            let user: User
            let cards: [Card]
            let transactions: [Transaction]
        }
    }

    enum ViewControllerState {
        case loading
        case empty
        case content(user: User, cards: [CardCellViewModel], transactions: [TransactionCellViewModel])
        case error(message: String)
    }
}
