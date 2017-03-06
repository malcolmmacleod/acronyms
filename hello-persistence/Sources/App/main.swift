import Vapor
import VaporPostgreSQL


let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations += Acronym.self

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.get("version") { req in
    if let db = drop.database?.driver as? PostgreSQLDriver {
        let version = try db.raw("SELECT version()")
        return try JSON(node: version)
    } else {
        return "No db connection"
    }
}

drop.get("model") { req in
    let acronym = Acronym(short: "JFK", long: "John F Kennedy")
    
    return try acronym.makeJSON()
}

drop.get("test") { req in
    var acronym = Acronym(short: "JFK", long: "John F Kennedy")
    try acronym.save()
    
    return try JSON(node: Acronym.all().makeNode())
}

drop.post("new") { req in
    
    var acronym = try Acronym(node: req.json)
    try acronym.save()
    
    return acronym
}

drop.get("all") { req in
    return try JSON(node: Acronym.all().makeNode())
}

drop.get("first") { req in
    return try JSON(node: Acronym.query().first()?.makeNode())
}

drop.get("short", String.self) { req, str in
    return try JSON(node: Acronym.query().filter("short", str).all().makeNode())
}

drop.put("update", String.self) { req, str in
   guard var first = try Acronym.query().filter("short", str).first(),
    let long = req.data["long"]?.string else {
        throw Abort.badRequest
    }
    
    first.long = long
    try first.save()
    return first
}

drop.delete("delete", String.self) { req, str in
    let query = try Acronym.query().filter("short", str)
    try query.delete()
    return try JSON(node: Acronym.all().makeNode())
}

drop.resource("posts", PostController())

drop.run()
