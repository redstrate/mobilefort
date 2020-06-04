import SwiftUI

struct ProfileView: View {
    let username: String
    
    @State var posts: [Post] = []
    
    var body: some View {
        VStack {
            List(posts) { post in
                PostView(post: post)
            }
        }.navigationBarTitle(username + "'s Feed").onAppear {
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
                        
                        DispatchQueue.main.sync {
                            self.posts = decodedPosts.posts
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
        //ProfileView()
        Text("Hello, world!")
    }
}
