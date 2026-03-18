import Foundation

enum NetworkError: Error, LocalizedError {
    case notFound
    case serverError
    case badStatusCode(Int)
    case timeout
    case noConnection
    case decodingFailed
    case unknown

    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Данные не найдены."
        case .serverError:
            return "Внутренняя ошибка сервера."
        case .badStatusCode(let code):
            return "Ошибка: \(code)."
        case .timeout:
            return "Превышено время ожидания."
        case .noConnection:
            return "Нет соединения с интернетом."
        case .decodingFailed:
            return "Не удалось разобрать ответ сервера."
        case .unknown:
            return "Неизвестная ошибка."
        }
    }
}
