import Vapor
import HTTP
import VaporPostgreSQL
import Turnstile

final class TILController {
    func addRoutes(drop: Droplet) {
        drop.get("til", handler: indexView)
        drop.post("til", handler: addAcronym)
        drop.post("til", Acronym.self, "delete", handler: deleteAcronym)
        drop.get("til/register", handler: registerView)
        drop.post("til/register", handler: register)
        drop.get("til/login", handler: loginView)
        drop.post("til/login", handler: login)
    }
    
    func indexView(request: Request) throws -> ResponseRepresentable {
        let user = try? request.auth.user() as! TILUser
        
        var acronyms : [Acronym]? = nil
        
        if let user = user {
            acronyms = try user.children(nil, Acronym.self).all()
        }
        
        let parameters = try Node(node: [
        "acronyms": acronyms?.makeNode(),
        "user": user?.makeNode(),
        "authenticated": user != nil,
        ])
        
        return try drop.view.make("index", parameters)
    }
    
    func addAcronym(request: Request) throws -> ResponseRepresentable {
        guard  let short = request.data["short"]?.string, let long = request.data["long"]?.string else {
            throw Abort.badRequest
        }
        
        var acronym = Acronym(short: short, long: long)
        try acronym.save()
        
        return Response(redirect: "/til")
    }
    
    func deleteAcronym(request: Request, acronym: Acronym) throws -> ResponseRepresentable {
        try acronym.delete()
        return Response(redirect: "/til")
    }
    
    func registerView(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("register")
    }
    
    func register(request: Request) throws -> ResponseRepresentable {
        guard  let name = request.formURLEncoded?["name"]?.string, let email = request.formURLEncoded?["email"]?.string, let password = request.formURLEncoded?["password"]?.string else {
            throw Abort.badRequest
        }
        
        _ = try TILUser.register(name: name, email: email, rawPassword: password)
        
        return Response(redirect: "/til")
    }
    
    func loginView(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("login")
    }
    
    func login(request: Request) throws -> ResponseRepresentable {
        guard let email = request.formURLEncoded?["email"]?.string, let password = request.formURLEncoded?["password"]?.string else {
            throw Abort.badRequest
        }
        
        let credentials = UsernamePassword(username: email, password: password)
        
        do {
            try request.auth.login(credentials)
            return Response(redirect: "/til")
        } catch let e as TurnstileError {
            return e.description
        }
    }
}
