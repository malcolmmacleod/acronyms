import Vapor

import Vapor

final class User : Model{
    
    var id: Node?
    var exists: Bool = false
    
    var name: Valid<NameValidator>
    var email: Valid<EmailValidator>
    var password: Valid<PasswordValidator>
    
    init (name: String, email: String, password: String) throws {
        self.name = try name.validated()
        self.email = try email.validated()
        self.password = try password.validated()
    }
    
    init (node: Node,  in context: Context ) throws {
        self.id = node["id"]
        let nameString = try node.extract("name") as String
        self.name = try nameString.validated()
        let emailString = try node.extract("email") as String
        self.email = try emailString.validated()
        let passwordString = try node.extract("password") as String
        self.password = try passwordString.validated()
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: ["id": id,
             "name": name.value,
             "email": email.value,
             "password": password.value])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("users") { users in
            users.id()
            users.string("name")
            users.string("email")
            users.string("password")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("users")
    }
}
