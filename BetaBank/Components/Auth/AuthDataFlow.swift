import Foundation

enum Auth {
    enum SignIn {
        struct Request {
            let password: String
            let email: String
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
            let firstName: String
            let lastName: String
            let password: String
            let email: String
        }
        
        struct Response {
            let result: Result<UUID, Error>
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
