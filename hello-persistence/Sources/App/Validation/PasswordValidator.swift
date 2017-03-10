import Vapor

class PasswordValidator : ValidationSuite {
    static func validate(input value: String) throws {
        let range = value.range(of: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$", options: .regularExpression)
        guard  let _ = range else {
            throw error(with: value)
        }
    }
}
