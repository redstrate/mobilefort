import SwiftUI

struct DescriptionView: View {
    var body: some View {
        Text("Hello, world!")
    }
}

struct ProfileView: View {
    let username: String
    
    @State var posts: [ParsedPostContainer] = []
    
    var body: some View {
        VStack {
            List(posts, id: \.post.id) { post in
                PostView(post: post)
            }
        }
        .navigationBarTitle(username + "'s Feed")
        .navigationBarItems(trailing: NavigationLink(destination: DescriptionView()) {
            Text("View Description")
        })
        .onAppear {
            let url = URL(string: "https://www.pillowfort.social/" + self.username + "/json")!
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                do {
                    if let jsonData = data {
                        struct Posts : Decodable {
                            let posts: [Post]
                        }
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        let decodedPosts = try decoder.decode(Posts.self, from: jsonData)
                        
                        var postArray = [ParsedPostContainer]()
                        
                        for post in decodedPosts.posts {
                            let container = ParsedPostContainer(post: post, contentAttributed: (try? NSMutableAttributedString(data: post.getContent().data(using: .utf8)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil))!)
                            postArray.append(container)
                        }
                        
                        DispatchQueue.main.sync {
                            self.posts = postArray
                        }
                    }
                } catch {
                    print("\(error)")
                }
            }.resume()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        //return ProfileView(username: "foobar", posts: [fooPost, fooPostReblog])
        Text("hello, world!")
    }
}
