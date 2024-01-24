import Foundation

public struct Card: Codable, Identifiable, Equatable, Hashable {
    public var id: String {
        url
    }
    
    public let url: String
    public let title: String?
    public let description: String?
    public let type: String
    public let image: URL?
    public let width: CGFloat
    public let height: CGFloat
    
    public static let preview: Card =
        .init(
            url: "https://www.theguardian.com/money/2019/dec/07/i-lost-my-193000-inheritance-with-one-wrong-digit-on-my-sort-code",
            title: "‘I lost my £193,000 inheritance – with one wrong digit on my sort code’",
            description: "When Peter Teich’s money went to another Barclays customer, the bank offered £25 as a token gesture",
            type: "link",
            image: URL(string: "https://files.mastodon.social/preview_cards/images/014/179/145/original/9cf4b7cf5567b569.jpeg"),
            width: 100,
            height: 150
        )
    
}

extension Card: Sendable {}
