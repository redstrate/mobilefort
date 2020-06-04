import SwiftUI
import RemoteImage

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
                        RemoteImage(type: .url(URL(string: media.url.encodeUrl()!)!), errorView: { error in
                            Text(error.localizedDescription)
                        }, imageView: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }, loadingView: {
                            Text("Loading...")
                        })
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
