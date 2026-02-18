import Foundation

enum TransactionDetails {
    enum LoadData {
        struct Request {
            let transactionId: UUID
        }

        struct Response {
            let result: Result<Transaction, Error>
        }

        struct ViewModel {
            let state: ViewControllerState
        }
    }

    enum ViewControllerState {
        case content(transaction: Transaction)
        case loading
        case error(message: String)
    }
}
