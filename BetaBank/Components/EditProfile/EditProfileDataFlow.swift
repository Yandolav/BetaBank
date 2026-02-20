import Foundation

enum EditProfile {
    enum LoadData {
        struct Request {
            let userId: UUID
        }

        struct Response {
            let result: Result<User, Error>
        }

        struct ViewModel {
            let state: ViewControllerState
        }
    }

    enum StartEditProfile {
        struct Request {}

        struct Response {}

        struct ViewModel {
            let state: ViewControllerState
        }
    }

    enum SaveNewData {
        struct Request {
            let userId: UUID
            let firstName: String
            let lastName: String
            let email: String
            let password: String
            let phone: String?
            let dataImage: Data?
        }

        struct Response {
            let result: Result<User, Error>
        }

        struct ViewModel {
            let state: ViewControllerState
        }
    }

    enum ViewControllerState {
        case content(user: User)
        case editing
        case saving
        case error(message: String)
    }
}

