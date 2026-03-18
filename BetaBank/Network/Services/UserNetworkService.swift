import Foundation

protocol UserNetworkServiceProtocol {
    func getAllUsers() async -> Result<[UserDTO], Error>
    func saveUser(_ user: UserDTO) async -> Result<[UserDTO], Error>
    func updateUser(_ user: UserDTO) async -> Result<[UserDTO], Error>
}

final class UserNetworkService: UserNetworkServiceProtocol {

    private let client: NetworkClientProtocol
    private let storage: any UserStorageProtocol
    private let baseURL = "https://alfaitmo.ru/server/echo/409950/users"

    init(client: NetworkClientProtocol, storage: any UserStorageProtocol) {
        self.client = client
        self.storage = storage
    }

    func getAllUsers() async -> Result<[UserDTO], Error> {
        let result: Result<[UserDTO], Error> = await client.get(url: baseURL)

        switch result {
        case .success(let dtos):
            dtos.forEach { _ = storage.upsert(entity: $0.toDomain()) }
            return .success(dtos)
        case .failure:
            let cached = storage.fetchAll().map { UserDTO(from: $0) }
            return cached.isEmpty ? result : .success(cached)
        }
    }

    func saveUser(_ user: UserDTO) async -> Result<[UserDTO], Error> {
        var users: [UserDTO] = []
        if case .success(let dtos) = await getAllUsers() {
            users = dtos
        }

        users.append(user)

        let result: Result<[UserDTO], Error> = await client.post(url: baseURL, body: users)

        if case .success = result {
            _ = storage.upsert(entity: user.toDomain())
        }
        return result
    }

    func updateUser(_ user: UserDTO) async -> Result<[UserDTO], Error> {
        var users: [UserDTO] = []
        if case .success(let dtos) = await getAllUsers() {
            users = dtos
        }

        guard let index = users.firstIndex(where: { $0.id == user.id }) else {
            return .failure(NetworkError.notFound)
        }

        users[index] = user

        let result: Result<[UserDTO], Error> = await client.post(url: baseURL, body: users)

        if case .success = result {
            _ = storage.upsert(entity: user.toDomain())
        }
        return result
    }
}
