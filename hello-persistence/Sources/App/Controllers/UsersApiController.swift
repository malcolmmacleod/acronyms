import Vapor
import HTTP
import VaporPostgreSQL

final class UsersApiController : ResourceRepresentable {
    func makeResource() -> Resource<TILUser> {
        return Resource(
            index: index,
            store: create,
            show: show,
            modify: update,
            destroy: delete
        )
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: TILUser.all().makeNode())
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var user = try request.user()
        try user.save()
        return user
    }
    
    func show(req: Request, user: TILUser) throws -> ResponseRepresentable {
        return user
    }
    
    func update(req: Request, user: TILUser) throws -> ResponseRepresentable {
        let newUser = try req.user()
        var user = user
        user.name = newUser.name
        user.email = newUser.email
        user.password = newUser.password
        
        try user.save()
        return user
    }
    
    func delete(req: Request, user: TILUser) throws -> ResponseRepresentable {
        try user.delete()
        return JSON([:])
    }
    
    func acronymsIndex(request: Request, user: TILUser) throws -> ResponseRepresentable {
        let children = try user.children(nil, Acronym.self).all()
        return try JSON(node: children.makeNode())
    }
}

extension Request {
    func user() throws -> TILUser {
        guard let json = json else { throw Abort.badRequest }
        return try TILUser(node: json)
    }
}
