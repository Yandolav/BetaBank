import Foundation

enum AddCard {
    enum SaveCard {
        struct Request {
            let userId: UUID
            let fullName: String
            let bankName: String
        }

        struct Response {
            let result: Result<Void, Error>
        }

        struct ViewModel {
            let state: ViewControllerState
        }
    }

    enum ViewControllerState {
        case content
        case loading
        case error(message: String)
    }
}
