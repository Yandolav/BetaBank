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
        case initial
        case loading
        case content(user: User, cards: [Card], transactions: [Transaction])
        case error(message: String)
    }
}
