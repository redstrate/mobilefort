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

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        return PostView(post: fooPost)
    }
}
