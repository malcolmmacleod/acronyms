import Vapor

final class Acronym : Model{
    
    var id: Node?
    var exists: Bool = false
    
    var short: String
    var long: String
    
    var userId: Node?
    
    init (short: String, long: String, userId: Node? = nil) {
        self.id = nil
        self.short = short
        self.long = long
        self.userId = userId
    }
    
    init (node: Node,  in context: Context ) throws {
        self.id = try node.extract("id")
        self.short = try node.extract("short")
        self.long = try node.extract("long")
        self.userId = try node.extract("user_id")

    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node:
            ["id": self.id,
             "short": self.short,
             "long": self.long,
             "user_id": self.userId])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("acronyms") { users in
            users.id()
            users.string("short")
            users.string("long")
            users.parent(TILUser.self, optional: false)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("acronyms")
    }
}
