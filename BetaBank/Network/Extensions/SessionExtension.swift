import Alamofire
import Foundation

extension Session {
    static let betaBankSession: Session = {
        let configuration = URLSessionConfiguration.default

        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData

        return Session(configuration: configuration)
    }()
}
