import Vapor
import HTTP
import VaporPostgreSQL

final class AcronymsController {
    func addRoutes(drop: Droplet) {
        let acronyms = drop.grouped("acronyms")
        acronyms.get("model", handler: model)
        acronyms.get("test", handler: test)
        acronyms.get("all", handler: all)
        acronyms.get("first", handler: first)
        acronyms.get("short", String.self,  handler: short)
        acronyms.post("new", handler: new)
        acronyms.put("update", String.self, handler: update)
        acronyms.delete("delete", String.self, handler: delete)

    }


    func model(req: Request) throws -> ResponseRepresentable {
        let acronym = Acronym(short: "JFK", long: "John F Kennedy")
    
        return try acronym.makeJSON()
    }
    
    func test(req: Request) throws -> ResponseRepresentable {
        var acronym = Acronym(short: "JFK", long: "John F Kennedy")
        try acronym.save()
    
        return try JSON(node: Acronym.all().makeNode())
    }
    
    func new(req: Request) throws -> ResponseRepresentable {
        var acronym = try Acronym(node: req.json)
        try acronym.save()
    
        return acronym
    }
    
    func all(req: Request) throws -> ResponseRepresentable {
        return try JSON(node: Acronym.all().makeNode())
    }
    
    func first(req: Request) throws -> ResponseRepresentable {
        return try JSON(node: Acronym.query().first()?.makeNode())
    }
    
    func short(req: Request, str: String) throws -> ResponseRepresentable {
        return try JSON(node: Acronym.query().filter("short", str).all().makeNode())
    }
    
    func update(req: Request, str: String) throws -> ResponseRepresentable {
        guard var first = try Acronym.query().filter("short", str).first(),
            let long = req.data["long"]?.string else {
                throw Abort.badRequest
        }
    
        first.long = long
        try first.save()
        return first
    }
    
    func delete(req: Request, str: String) throws -> ResponseRepresentable {
        let query = try Acronym.query().filter("short", str).first()
        try query?.delete()
        return try JSON(node: Acronym.all().makeNode())
    }

}
