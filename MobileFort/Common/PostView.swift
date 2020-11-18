import SwiftUI
import URLImage

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
                URLImage(url: URL(string: post.post.avatarUrl.encodeUrl()!)!) { image in
                    image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                }.frame(width: 50.0, height: 50.0).padding(.leading)
                
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
                            URLImage(url: URL(string: media.url.encodeUrl()!)!) { image in
                                image
                                    .aspectRatio(contentMode: .fit)
                            }
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
