import Vapor
import HTTP
import VaporPostgreSQL
import Turnstile


final class TILUsersController {
    func addRoutes(drop: Droplet) {
        drop.get("til/users", handler: indexView)
        drop.post("til/users", handler: addUser)
        drop.post("til/users", TILUser.self, "delete", handler: deleteUser)
        drop.get("til/users", TILUser.self, "acronyms", handler: acronymsIndex)
       

    }
    
    func indexView(request: Request) throws -> ResponseRepresentable {
        let users = try TILUser.all().makeNode()
        
        let parameters = try Node(node: [
            "users": users
            ])
        
        return try drop.view.make("index", parameters)
    }
    
    func addUser(request: Request) throws -> ResponseRepresentable {
        guard  let name = request.data["name"]?.string, let email = request.data["email"]?.string, let password = request.data["password"]?.string else {
            throw Abort.badRequest
        }
        
        var user = try TILUser(name: name, email: email, rawPassword: password)
        try user.save()
        
        return Response(redirect: "/til/users")
    }
    
    func deleteUser(request: Request, user: TILUser) throws -> ResponseRepresentable {
        try user.delete()
        return Response(redirect: "/til/users")
    }
    
    func acronymsIndex(request: Request, user: TILUser) throws -> ResponseRepresentable {
        let children = try user.children(nil, Acronym.self).all()
        return try JSON(node: children.makeNode())
    }
}
