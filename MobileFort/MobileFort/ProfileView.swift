import SwiftUI

extension NSMutableAttributedString {
    func with(font: UIFont) -> NSMutableAttributedString {
        enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, length), options: .longestEffectiveRangeNotRequired, using: { (value, range, stop) in
            if let originalFont = value as? UIFont, let newFont = applyTraitsFromFont(originalFont, to: font) {
                addAttribute(NSAttributedString.Key.font, value: newFont, range: range)
            }
        })
        
        return self
    }
    
    func applyTraitsFromFont(_ originalFont: UIFont, to newFont: UIFont) -> UIFont? {
        let originalTrait = originalFont.fontDescriptor.symbolicTraits
        
        if originalTrait.contains(.traitBold) {
            var traits = newFont.fontDescriptor.symbolicTraits
            traits.insert(.traitBold)
            
            if let fontDescriptor = newFont.fontDescriptor.withSymbolicTraits(traits) {
                return UIFont.init(descriptor: fontDescriptor, size: 0)
            }
        }
        
        return newFont
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
                        
                        var postArray = [ParsedPostContainer]()
                        
                        for post in decodedPosts.posts {
                            let container = ParsedPostContainer(post: post, contentAttributed: (try? NSMutableAttributedString(data: post.getContent().data(using: .utf8)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil))!.with(font: UIFont.preferredFont(forTextStyle: .body)))
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
