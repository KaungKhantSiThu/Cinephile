import Foundation
import Alamofire

public struct RegisterModel : Codable, Sendable {
    var username : String
    var email : String
    var password : String
    var agreement : Bool
    var reason : String
    var locale : String
    
    init(username: String, email: String, password: String, agreement: Bool = true, reason: String = "test", locale: String = "en") {
        self.username = username
        self.email = email
        self.password = password
        self.agreement = agreement
        self.reason = reason
        self.locale = locale
    }
}

class SignUpViewModel {
    static var shared = SignUpViewModel()
    
    func createData(reigsterModel : RegisterModel) {
        let header : HTTPHeaders = [
            .authorization(bearerToken: "x-t8FUzquP4JsihXzWhzsbAFN1k7zoysO-DdImGMcwM"),
            .contentType("application/json")
        ]
        guard let url = URL(string: "https://polar-brushlands-19893-4c4dfbb9419d.herokuapp.com/api/v1/accounts") else { return }
        
        AF.request(url, method: .post, parameters: reigsterModel, encoder: JSONParameterEncoder.default, headers: header).response { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(json)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
