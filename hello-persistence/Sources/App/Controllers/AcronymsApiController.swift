import Vapor
import HTTP
import VaporPostgreSQL

final class AcronymsApiController : ResourceRepresentable {
    func makeResource() -> Resource<Acronym> {
        return Resource(
            index: index,
            store: create,
            show: show,
            modify: update,
            destroy: delete
        )
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Acronym.all().makeNode())
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var acronym = try request.acronym()
        try acronym.save()
        return acronym
    }
    
    func show(req: Request, acronym: Acronym) throws -> ResponseRepresentable {
        return acronym
    }
    
    func update(req: Request, acronym: Acronym) throws -> ResponseRepresentable {
        let newAcronym = try req.acronym()
        var acronym = acronym
        acronym.short = newAcronym.short
        acronym.long = newAcronym.long
        
        try acronym.save()
        return acronym
    }
    
    func delete(req: Request, acronym: Acronym) throws -> ResponseRepresentable {
        try acronym.delete()
        return JSON([:])
    }
}

extension Request {
    func acronym() throws -> Acronym {
        guard let json = json else { throw Abort.badRequest }
        return try Acronym(node: json)
    }
}
