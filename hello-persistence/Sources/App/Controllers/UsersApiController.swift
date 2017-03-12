import Vapor
import HTTP
import VaporPostgreSQL

final class UsersApiController : ResourceRepresentable {
    func makeResource() -> Resource<User> {
        return Resource(
            index: index,
            store: create,
            show: show,
            modify: update,
            destroy: delete
        )
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: User.all().makeNode())
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var user = try request.user()
        try user.save()
        return user
    }
    
    func show(req: Request, user: User) throws -> ResponseRepresentable {
        return user
    }
    
    func update(req: Request, user: User) throws -> ResponseRepresentable {
        let newUser = try req.user()
        var user = user
        user.name = newUser.name
        user.email = newUser.email
        user.password = newUser.password
        
        try user.save()
        return user
    }
    
    func delete(req: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return JSON([:])
    }
    
    func acronymsIndex(request: Request, user: User) throws -> ResponseRepresentable {
        let children = try user.children(nil, Acronym.self).all()
        return try JSON(node: children.makeNode())
    }
}

extension Request {
    func user() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        return try User(node: json)
    }
}
