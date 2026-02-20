import Foundation

enum CardDetails {
    enum LoadData {
        struct Request {
            let cardId: UUID
        }

        struct Response {
            let result: Result<Card, Error>
        }

        struct ViewModel {
            let state: ViewControllerState
        }
    }

    enum ViewControllerState {
        case content(card: Card)
        case loading
        case error(message: String)
    }
}
