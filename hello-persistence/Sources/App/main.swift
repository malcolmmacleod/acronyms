import Vapor
import VaporPostgreSQL


let drop = Droplet()

(drop.view as? LeafRenderer)?.stem.cache = nil

try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations += Acronym.self

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

let basic = BasicController()
basic.addRoutes(drop: drop)

//let acronyms = AcronymsController()
// acronyms.addRoutes(drop: drop)

let acronymsApi = AcronymsApiController()
drop.resource("acronyms", acronymsApi)

let til = TILController()
til.addRoutes(drop: drop)

drop.resource("posts", PostController())

drop.run()
