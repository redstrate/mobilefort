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
    let avatarUrl: String
    
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

let mediaURL = "https://homepages.cae.wisc.edu/~ece533/images/airplane.png"

let testMedia = Media(id: 0,
                      url: mediaURL)

let fooPost = Post(id: 0,
                   title: "Foo",
                   content: "",
                   postType: .picture,
                   media: [testMedia],
                   username: "foobar",
                   originalUsername: nil,
                   originalPost: nil,
                   avatarUrl: mediaURL)

let fooPostReblog = Post(id: 1,
                         title: nil,
                         content: "",
                         postType: .picture,
                         media: [testMedia],
                         username: "foobar",
                         originalUsername: "foobar2",
                         originalPost: nil,
                         avatarUrl: mediaURL)
