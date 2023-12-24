import Foundation

struct SignUpModel : Codable, Sendable {
    var username : String
    var email : String
    var password : String
    var aggreement : Bool
    var reason : String
    var locale : String
    
    init(username: String, email: String, password: String, aggreement: Bool = true, reason: String = "test", locale: String = "en") {
        self.username = username
        self.email = email
        self.password = password
        self.aggreement = aggreement
        self.reason = reason
        self.locale = locale
    }
}

