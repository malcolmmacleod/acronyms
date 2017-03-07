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

let basic = BasicController()
basic.addRoutes(drop: drop)

let acronyms = AcronymsController()
acronyms.addRoutes(drop: drop)

drop.resource("posts", PostController())

drop.run()
