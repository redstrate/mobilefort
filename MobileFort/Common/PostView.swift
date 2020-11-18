import SwiftUI
import RemoteImage

extension String {
    func encodeUrl() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}

struct PostView: View {
    let post: ParsedPostContainer
    
    var body: some View {
        VStack {
            HStack {
                RemoteImage(type: .url(URL(string: post.post.avatarUrl.encodeUrl()!)!), errorView: { error in
                    Text(error.localizedDescription)
                }, imageView: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }, loadingView: {
                    Text("Loading...")
                }).frame(width: 50.0, height: 50.0).padding(.leading)
                
                VStack(alignment: .leading) {
                    if post.post.isReblogged() {
                        Text(post.post.username + " reblogged from " + post.post.originalUsername!).foregroundColor(.gray)
                    }
                    
                    if post.post.getTitle() != nil {
                        Text(post.post.getTitle()!)
                    }
                }
                
                Spacer()
            }.frame(maxWidth: .infinity)
            
            VStack {
                ForEach(post.post.media) { media in
                    if !media.url.isEmpty {
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
            
            AttributedText(post.contentAttributed)
        }.frame(maxWidth: .infinity)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        return PostView(post: ParsedPostContainer(post: fooPost, contentAttributed: NSMutableAttributedString()))
    }
}
