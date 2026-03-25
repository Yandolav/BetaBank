import Foundation

protocol Storage {
    associatedtype Entity

    func fetch(id: UUID) -> Result<Entity, Error>
    func fetchAll() -> [Entity]
    func create(entity: Entity) -> Result<Void, Error>
    func delete(id: UUID) -> Result<Void, Error>
    func update(id: UUID, entity: Entity) -> Result<Void, Error>
    func upsert(entity: Entity) -> Result<Void, Error>
}
