import Foundation

enum PostType: String, Decodable {
    case picture
}

struct Media: Decodable, Identifiable {
    let id: Int
    
    let url: String
}

struct OriginalPost: Decodable, Identifiable {
    let id: Int
    
    let title: String?
}

struct Post: Decodable, Identifiable {
    let id: Int
    
    let title: String?
    let content: String
    
    let postType: PostType
    
    let media: [Media]
    
    let username: String
    let originalUsername: String?
    
    let originalPost: OriginalPost?
    
    func isReblogged() -> Bool {
        return originalUsername != nil
    }
    
    func getTitle() -> String? {
        if isReblogged() {
            return originalPost?.title
        } else {
            return title
        }
    }
}
