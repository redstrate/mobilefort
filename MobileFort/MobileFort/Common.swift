import Foundation

enum PostType: String, Decodable {
    case picture
}

struct Post: Decodable, Identifiable {
    let id: Int
    
    let title: String?
    let content: String
    
    let postType: PostType
}
