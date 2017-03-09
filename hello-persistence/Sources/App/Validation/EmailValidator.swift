import Vapor

class EmailValidator : ValidationSuite {
    static func validate(input value: String) throws {
        let evaluation = Email.self
        try evaluation.validate(input: value)
    }
}
