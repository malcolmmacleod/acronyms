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



drop.resource("posts", PostController())

drop.run()
