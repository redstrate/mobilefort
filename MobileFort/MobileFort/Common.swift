import Foundation

enum PostType: String, Decodable {
    case picture
}

struct Media: Decodable, Identifiable {
    let id: Int
    
    let url: String
}

struct Post: Decodable, Identifiable {
    let id: Int
    
    let title: String?
    let content: String
    
    let postType: PostType
    
    let media: [Media]
}
