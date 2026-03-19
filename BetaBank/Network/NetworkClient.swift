import Alamofire
import Foundation

protocol NetworkClientProtocol {
    func get<Response: Decodable>(url: String) async -> Result<Response, Error>
    func post<Body: Encodable, Response: Decodable>(url: String, body: Body) async -> Result<Response, Error>
    func put<Body: Encodable, Response: Decodable>(url: String, body: Body) async -> Result<Response, Error>
    func patch<Body: Encodable, Response: Decodable>(url: String, body: Body) async -> Result<Response, Error>
}

final class NetworkClient: NetworkClientProtocol {

    // MARK: Private properties

    private let session: Session
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    // MARK: Init

    init(session: Session = .betaBankSession) {
        self.session = session

        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601

        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601
    }

    // MARK: Public methods

    func get<Response: Decodable>(url: String) async -> Result<Response, Error> {
        let dataRequest = session
            .request(url, method: .get)
            .validate(statusCode: [200])

        return await withTaskCancellationHandler {
            let response = await dataRequest
                .serializingDecodable(Response.self, decoder: decoder)
                .response
            return handle(response)
        } onCancel: {
            dataRequest.cancel()
        }
    }

    func post<Body: Encodable, Response: Decodable>(url: String, body: Body) async -> Result<Response, Error> {
        let dataRequest = session
            .request(url, method: .post, parameters: body, encoder: JSONParameterEncoder(encoder: encoder))
            .validate(statusCode: [201])

        return await withTaskCancellationHandler {
            let response = await dataRequest
                .serializingDecodable(Response.self, decoder: decoder)
                .response
            return handle(response)
        } onCancel: {
            dataRequest.cancel()
        }
    }

    func put<Body: Encodable, Response: Decodable>(url: String, body: Body) async -> Result<Response, Error> {
        let dataRequest = session
            .request(url, method: .put, parameters: body, encoder: JSONParameterEncoder(encoder: encoder))
            .validate(statusCode: [201])

        return await withTaskCancellationHandler {
            let response = await dataRequest
                .serializingDecodable(Response.self, decoder: decoder)
                .response
            return handle(response)
        } onCancel: {
            dataRequest.cancel()
        }
    }

    func patch<Body: Encodable, Response: Decodable>(url: String, body: Body) async -> Result<Response, Error> {
        let dataRequest = session
            .request(url, method: .patch, parameters: body, encoder: JSONParameterEncoder(encoder: encoder))
            .validate(statusCode: [201])

        return await withTaskCancellationHandler {
            let response = await dataRequest
                .serializingDecodable(Response.self, decoder: decoder)
                .response
            return handle(response)
        } onCancel: {
            dataRequest.cancel()
        }
    }

    // MARK: Private methods

    private func handle<Response>(_ response: DataResponse<Response, AFError>) -> Result<Response, Error> {
        switch response.result {
        case .success(let value):
            return .success(value)

        case .failure:
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 404: return .failure(NetworkError.notFound)
                case 500: return .failure(NetworkError.serverError)
                default: return .failure(NetworkError.badStatusCode(statusCode))
                }
            }

            guard let afError = response.error else {
                return .failure(NetworkError.unknown)
            }

            if afError.isSessionTaskError,
               let urlError = afError.underlyingError as? URLError {
                switch urlError.code {
                case .timedOut: return .failure(NetworkError.timeout)
                case .notConnectedToInternet: return .failure(NetworkError.noConnection)
                default: break
                }
            }

            if case .responseSerializationFailed = afError {
                return .failure(NetworkError.decodingFailed)
            }

            return .failure(NetworkError.unknown)
        }
    }
}
