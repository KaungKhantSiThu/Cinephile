import Foundation

class SignUpViewModel {
    static let shared = SignUpViewModel()

    func signUp(user: SignUpModel, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "https://polar-brushlands-19893-4c4dfbb9419d.herokuapp.com/api/v1/accounts") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(user)
            request.httpBody = userData

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    return
                }

                completion(.success(data))
            }

            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
