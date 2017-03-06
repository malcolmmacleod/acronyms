import Vapor

final class Acronym : Model{
    
    var id: Node?
    var exists: Bool = false
    
    var short: String
    var long: String
    
    init (short: String, long: String) {
        self.id = nil
        self.short = short
        self.long = long
    }
    
    init (node: Node,  in context: Context ) throws {
        self.id = try node.extract("id")
        self.short = try node.extract("short")
        self.long = try node.extract("long")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node:
            ["id": self.id,
             "short": self.short,
             "long": self.long])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("acronyms") { users in
            users.id()
            users.string("short")
            users.string("long")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("acronyms")
    }
}
