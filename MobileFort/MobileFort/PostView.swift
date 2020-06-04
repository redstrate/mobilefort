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
            HStack {
                RemoteImage(type: .url(URL(string: post.avatarUrl.encodeUrl()!)!), errorView: { error in
                    Text(error.localizedDescription)
                }, imageView: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }, loadingView: {
                    Text("Loading...")
                }).frame(width: 50.0, height: 50.0).padding(.leading)
                
                VStack(alignment: .leading) {
                    if post.isReblogged() {
                        Text(post.username + " reblogged from " + post.originalUsername!).foregroundColor(.gray)
                    }
                    
                    if post.getTitle() != nil {
                        Text(post.getTitle()!)
                    }
                }
                
                Spacer()
            }.frame(maxWidth: .infinity)
            
            VStack {
                ForEach(post.media) { media in
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
        }.frame(maxWidth: .infinity)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        return PostView(post: fooPost)
    }
}
