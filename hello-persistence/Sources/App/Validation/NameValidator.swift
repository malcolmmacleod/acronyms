import Vapor

class NameValidator : ValidationSuite {
    static func validate(input value: String) throws {
        let range = value.range(of: "^[A-Za-z ,.'-]+$", options: [.regularExpression, .caseInsensitive])
        guard  let _ = range else {
            throw error(with: value)
        }
    }

}
