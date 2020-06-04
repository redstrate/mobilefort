import SwiftUI
import RemoteImage

extension String {
    func encodeUrl() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}

final class AttributedTextComponent: UIViewRepresentable {
    let string: NSAttributedString
    
    init(_ string: NSAttributedString) {
        self.string = string
    }
    
    public func makeUIView(context: UIViewRepresentableContext<AttributedTextComponent>) -> UILabel {
        UILabel()
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.backgroundColor = .clear
        uiView.numberOfLines = 0
        uiView.lineBreakMode = .byWordWrapping
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        uiView.attributedText = string
    }
}

struct AttributedText: View {
    let html: NSAttributedString
    let component: AttributedTextComponent
    
    @State var height: CGFloat = 0.0
    
    init(_ html: NSAttributedString) {
        self.html = html
        self.component = AttributedTextComponent(html)
    }
        
    var body: some View {
        component.onAppear {
            let label = UILabel()
            
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            label.attributedText = self.html
            label.sizeToFit()
            
            self.height = label.frame.height + 15.0 // for padding
        }.frame(minWidth: 0.0, maxWidth: .infinity, minHeight: 0.0, maxHeight: height)
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
        return PostView(post: ParsedPostContainer(post: fooPost, contentAttributed: NSAttributedString()))
    }
}
