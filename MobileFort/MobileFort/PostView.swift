import SwiftUI
import RemoteImage

extension String {
    func encodeUrl() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}

/// A custom view to use NSAttributedString in SwiftUI
struct AttributedText: UIViewRepresentable {
    func updateUIView(_ uiView: UILabel, context: Context) {
        
    }
    
    let html: String
    
    init(_ html: String) {
        self.html = html
    }
    
    public func makeUIView(context: UIViewRepresentableContext<AttributedText>) -> UILabel {
        let textView = UILabel()
        textView.backgroundColor = .clear
        textView.lineBreakMode = .byWordWrapping
        textView.numberOfLines = 0
        textView.lineBreakMode = .byWordWrapping
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        DispatchQueue.main.async {
            let data = Data(self.html.utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                textView.attributedText = attributedString
            }
        }
                
        return textView
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
                
                AttributedText(post.getContent()).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
        }.frame(maxWidth: .infinity)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        return PostView(post: fooPost)
    }
}
