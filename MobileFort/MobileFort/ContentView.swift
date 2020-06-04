import SwiftUI

struct ProfileView: View {
    let username: String
    
    @State var posts: [Post] = []
    
    var body: some View {
        VStack {
            List(posts) { post in
                Text(String(post.id))
            }
        }.navigationBarTitle(username + "'s Feed").onAppear {
            let url = URL(string: "https://www.pillowfort.social/" + self.username + "/json")!

            URLSession.shared.dataTask(with: url) { (data, response, error) in
                do {
                    if let jsonData = data {
                        struct Posts : Decodable {
                            let posts: [Post]
                        }
                        
                        let decodedPosts = try JSONDecoder().decode(Posts.self, from: jsonData)
                        
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
