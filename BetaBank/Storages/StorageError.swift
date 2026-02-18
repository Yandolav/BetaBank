import Foundation

enum StorageError: Error, LocalizedError {
    case incorrectId
    case existingEntity

    var errorDescription: String? {
        switch self {
        case .incorrectId:
            return "Сущности с такими индификатором не существует"
        case .existingEntity:
            return "Сущность с таким индификатором уже существует"
        }
    }
}
