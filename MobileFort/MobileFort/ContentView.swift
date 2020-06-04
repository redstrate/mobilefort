import SwiftUI
import URLImage

extension String {
    func encodeUrl() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}

struct PostView: View {
    let post: Post
    
    var body: some View {
        VStack {
            if post.isReblogged() {
                Text("Reblogged from " + post.originalUsername!)
            }
            
            if post.getTitle() != nil {
                Text(post.getTitle()!)
            }
            
            VStack {
                ForEach(post.media) { media in
                    VStack {
                        URLImage(URL(string: media.url.encodeUrl()!)!,
                                 delay: 0.25) { proxy in
                            proxy.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
            }
        }
    }
}

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

struct MainView: View {
    @State private var username: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Username", text: $username)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                NavigationLink(destination: ProfileView(username: username)) {
                    Text("Show Feed")
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
