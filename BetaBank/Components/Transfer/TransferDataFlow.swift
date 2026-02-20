import Foundation

enum Transfer {
    enum LoadCards {
        struct Request {
            let userId: UUID
        }

        struct Response {
            let result: Result<[Card], Error>
        }

        struct ViewModel {
            let state: ViewControllerState
        }
    }

    enum Transfer {
        struct Request {
            let userId: UUID
            let amountMinor: Int
            let comment: String?
            let fromCard: UUID
            let toCard: UUID
        }

        struct Response {
            let result: Result<Void, Error>
        }

        struct ViewModel {
            let state: ViewControllerState
        }
    }

    enum ViewControllerState {
        case content(cards: [Card])
        case loading
        case error(message: String)
    }
}
