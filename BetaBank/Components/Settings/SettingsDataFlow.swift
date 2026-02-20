import Foundation

enum Settings {
    enum DeleteAccount {
        struct Request {
            let userId: UUID
        }

        struct Response {
            let result: Result<Void, Error>
        }

        struct ViewModel {
            let state: ViewControllerState
        }
    }

    enum Logout {
        struct Request {
            let userId: UUID
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
