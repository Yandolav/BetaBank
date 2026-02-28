import Foundation

protocol CodableStore {
    func load<T: Decodable>(_ type: T.Type, fileName: String, defaultValue: T) -> T
    func save<T: Encodable>(_ value: T, fileName: String) -> Result<Void, Error>
}

class FileDataStore: CodableStore  {

    private let baseDirectory: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        baseDirectory: URL = FileManager.default.urls(for: .libraryDirectory, in: .allDomainsMask).first!,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseDirectory = baseDirectory
        self.encoder = encoder
        self.decoder = decoder
    }

    func load<T>(_ type: T.Type, fileName: String, defaultValue: T) -> T where T : Decodable {
        let url = baseDirectory.appendingPathComponent(fileName)

        do {
            let data = try Data(contentsOf: url)
            let obj = try decoder.decode(type, from: data)
            return obj
        } catch {
            return defaultValue
        }
    }

    func save<T>(_ value: T, fileName: String) -> Result<Void, Error> where T : Encodable {
        let url = baseDirectory.appendingPathComponent(fileName)

        do {
            let data = try encoder.encode(value)
            try data.write(to: url)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
