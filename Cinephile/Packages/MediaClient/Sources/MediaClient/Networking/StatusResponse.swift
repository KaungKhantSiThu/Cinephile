import Foundation

struct StatusResponse: Decodable {

    let success: Bool
    let statusCode: Int
    let statusMessage: String

}
