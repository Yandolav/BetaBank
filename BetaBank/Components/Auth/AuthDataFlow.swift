import Foundation

enum Auth {
    enum SignIn {
        struct Request {
            let password: String?
            let email: String?
        }

        struct Response {
            let result: Result<UUID, Error>
        }

        struct ViewModel {
            let state: ViewControllerState
        }
    }

    enum SignUp {
        struct Request {
            let firstName: String?
            let lastName: String?
            let password: String?
            let email: String?
        }

        struct Response {
            let result: Result<UUID, Error>
        }

        struct ViewModel {
            let state: ViewControllerState
        }
    }

    enum FirstNameValidate {
        struct Request {
            let firstName: String?
        }

        struct Response {
            let result: Result<Void, Error>
        }

        struct ViewModel {
            let state: ViewControllerState
        }
    }

    enum LastNameValidate {
        struct Request {
            let lastName: String?
        }

        struct Response {
            let result: Result<Void, Error>
        }

        struct ViewModel {
            let state: ViewControllerState
        }
    }

    enum EmailValidate {
        struct Request {
            let email: String?
        }

        struct Response {
            let result: Result<Void, Error>
        }

        struct ViewModel {
            let state: ViewControllerState
        }
    }

    enum PasswordValidate {
        struct Request {
            let password: String?
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
        case error(message: String)
    }
}
