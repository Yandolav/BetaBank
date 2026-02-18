import Foundation

protocol Storage {
    associatedtype Entity

    func fetch(id: UUID) throws -> Entity
    func fetchAll() throws -> [Entity]
    func create(entity: Entity) throws
    func delete(id: UUID) throws
    func update(id: UUID, entity: Entity) throws
}
