import Foundation

protocol CardServiceProtocol {
    func getCard(cardId: UUID) -> Result<Card, Error>

    func getAllCards(userId: UUID) -> Result<[Card], Error>

    func deleteCard(cardId: UUID) -> Result<Void, Error>

    func createCard(
        userID: UUID,
        userFullName: String,
        bankName: String
    ) -> Result<Void, Error>
}

final class CardService {

    // MARK: Private properties

    private let cardStorage: any CardStorageProtocol

    // MARK: Init

    init(cardStorage: any CardStorageProtocol) {
        self.cardStorage = cardStorage
    }
}

// MARK: - CardServiceProtocol

extension CardService: CardServiceProtocol {
    func getCard(cardId: UUID) -> Result<Card, Error> {
        .failure(StorageError.existingEntity)
    }
    
    func getAllCards(userId: UUID) -> Result<[Card], Error> {
        .failure(StorageError.existingEntity)
    }
    
    func deleteCard(cardId: UUID) -> Result<Void, Error> {
        .failure(StorageError.existingEntity)
    }
    
    func createCard(userID: UUID, userFullName: String, bankName: String) -> Result<Void, Error> {
        .failure(StorageError.existingEntity)
    }
}

// MARK: - TransactionServiceError

extension CardService {
    enum CardServiceError: Error, LocalizedError {
        case cardNotFound(cardId: UUID)
        case userNotFound(userId: UUID)
        case cardAlreadyExists(cardId: UUID)
        case emptyUserFullName
        case invalidUserFullName
        case emptyBankName
        case invalidBankName
        case cannotDeleteActiveCard(cardId: UUID)
        case cardBlocked(cardId: UUID)
        case failedToLoadCards
        case failedToSaveCard
        case failedToDeleteCard
        case unknown(underlying: Error)

        var errorDescription: String? {
            switch self {
            case .cardNotFound(let id):
                return "Карта с id \(id.uuidString) не найдена."
            case .userNotFound(let id):
                return "Пользователь с id \(id.uuidString) не найден."
            case .cardAlreadyExists(let id):
                return "Карта с id \(id.uuidString) уже существует."
            case .emptyUserFullName:
                return "ФИО владельца не может быть пустым."
            case .invalidUserFullName:
                return "Некорректное ФИО владельца."
            case .emptyBankName:
                return "Название банка не может быть пустым."
            case .invalidBankName:
                return "Некорректное название банка."
            case .cannotDeleteActiveCard(let id):
                return "Нельзя удалить активную карту (id \(id.uuidString))."
            case .cardBlocked(let id):
                return "Операция невозможна: карта \(id.uuidString) заблокирована."
            case .failedToLoadCards:
                return "Не удалось получить список карт."
            case .failedToSaveCard:
                return "Не удалось сохранить карту."
            case .failedToDeleteCard:
                return "Не удалось удалить карту."
            case .unknown(let underlying):
                return "Неизвестная ошибка: \(underlying.localizedDescription)"
            }
        }
    }
}
