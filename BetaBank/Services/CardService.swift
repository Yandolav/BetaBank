import Foundation

protocol CardServiceProtocol {
    func getAllCards(userId: UUID) async -> Result<[Card], Error>
    func createCard(userID: UUID, userFullName: String, bankName: String) async -> Result<Void, Error>
}

final class CardService {

    // MARK: Private properties

    private let networkService: any CardNetworkServiceProtocol

    // MARK: Init

    init(networkService: any CardNetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: Private methods

    private func validateUserFullName(_ value: String) -> Result<Void, Error> {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .failure(CardServiceError.emptyUserFullName) }
        let parts = trimmed.split(separator: " ")
        guard parts.count >= 2, parts.allSatisfy({ $0.allSatisfy({ $0.isLetter }) }) else {
            return .failure(CardServiceError.invalidUserFullName)
        }
        return .success(())
    }

    private func validateBankName(_ value: String) -> Result<Void, Error> {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .failure(CardServiceError.emptyBankName) }
        guard trimmed.count >= 2 else { return .failure(CardServiceError.invalidBankName) }
        return .success(())
    }

    private func generateCardNumber() -> String {
        (0..<4)
            .map { _ in String(format: "%04d", Int.random(in: 0...9999)) }
            .joined(separator: " ")
    }

    private func generateCode() -> String {
        String(format: "%03d", Int.random(in: 0...999))
    }

    private func generateValidatePeriod() -> Date {
        Calendar.current.date(byAdding: .year, value: 4, to: Date()) ?? Date()
    }
}

// MARK: - CardServiceProtocol

extension CardService: CardServiceProtocol {

    func getAllCards(userId: UUID) async -> Result<[Card], Error> {
        let result = await networkService.getAllCards()

        switch result {
        case .success(let dtos):
            let cards = dtos
                .map { $0.toDomain() }
                .filter { $0.userID == userId }
            return .success(cards)
        case .failure(let error):
            return .failure(error)
        }
    }

    func createCard(
        userID: UUID,
        userFullName: String,
        bankName: String
    ) async -> Result<Void, Error> {
        if case .failure(let error) = validateUserFullName(userFullName) { return .failure(error) }
        if case .failure(let error) = validateBankName(bankName) { return .failure(error) }

        let dto = CardDTO(
            id: UUID(),
            userID: userID,
            balance: 0,
            number: generateCardNumber(),
            userFullName: userFullName,
            validatePeriod: generateValidatePeriod(),
            bankName: bankName,
            code: generateCode()
        )

        let result = await networkService.saveCard(dto)

        switch result {
        case .success: return .success(())
        case .failure(let error): return .failure(error)
        }
    }
}

// MARK: - CardServiceError

extension CardService {
    enum CardServiceError: Error, LocalizedError {
        case cardNotFound(cardId: UUID)
        case emptyUserFullName
        case invalidUserFullName
        case emptyBankName
        case invalidBankName
        case failedToLoadCards
        case failedToSaveCard
        case unknown(underlying: Error)

        var errorDescription: String? {
            switch self {
            case .cardNotFound(let id): return "Карта с id \(id.uuidString) не найдена."
            case .emptyUserFullName: return "ФИО владельца не может быть пустым."
            case .invalidUserFullName: return "Некорректное ФИО владельца."
            case .emptyBankName: return "Название банка не может быть пустым."
            case .invalidBankName: return "Некорректное название банка."
            case .failedToLoadCards: return "Не удалось получить список карт."
            case .failedToSaveCard: return "Не удалось сохранить карту."
            case .unknown(let underlying): return "Неизвестная ошибка: \(underlying.localizedDescription)"
            }
        }
    }
}
