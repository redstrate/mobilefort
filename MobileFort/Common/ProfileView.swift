import SwiftUI
import WebKit

#if !os(macOS)
import WebView
#endif

struct DescriptionView: View {
    let username: String
    
    private func replaceDOM(selector: String) -> String {
        return
            """
            var selectedElement = document.querySelector('\(selector)');
            document.body.innerHTML = selectedElement.innerHTML;
            """
    }
    
    var webView: WKWebView {
        let configuration = WKWebViewConfiguration()
        
        let blockRules = """
         [{
             "trigger": {
                 "url-filter": ".*",
                 "resource-type": ["script"]
             },
             "action": {
                 "type": "block"
             }
         }]
        """

        WKContentRuleListStore.default().compileContentRuleList(
            forIdentifier: "ContentBlockingRules",
            encodedContentRuleList: blockRules) { (contentRuleList, error) in
                configuration.userContentController.add(contentRuleList!)
        }
        
        let userScript = WKUserScript(source: replaceDOM(selector: "#description"),
                                      injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
                                      forMainFrameOnly: true)
        
        configuration.userContentController.addUserScript(userScript)
        
        let view = WKWebView(frame: .zero, configuration: configuration)
        view.load(URLRequest(url: URL(string: "https://www.pillowfort.social/" + self.username)!))
        
        return view
    }
    
    @ViewBuilder
    var body: some View {
        #if !os(macOS)
        VStack {
            WebView(webView: webView)
        }.navigationBarTitle("Sidebar", displayMode: .inline)
        #else
        Text("Not supported on macOS.")
        #endif
    }
}

struct ProfileView: View {
    let username: String
    
    @State var posts: [ParsedPostContainer] = []
    
    #if os(iOS)
    var body: some View {
        List(posts, id: \.post.id) { post in
            PostView(post: post)
        }
        .navigationBarTitle(username)
        .navigationBarItems(trailing: NavigationLink(destination: DescriptionView(username: username)) {
            Text("Sidebar")
        })
        .onAppear {
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
                            let container = ParsedPostContainer(post: post, contentAttributed: (try? NSMutableAttributedString(data: post.getContent().data(using: .utf8)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil))!)
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
    #else
    var body: some View {
        List(posts, id: \.post.id) { post in
            PostView(post: post)
        }
        .onAppear {
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
                            let container = ParsedPostContainer(post: post, contentAttributed: (try? NSMutableAttributedString(data: post.getContent().data(using: .utf8)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil))!)
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
    #endif
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        //return ProfileView(username: "foobar", posts: [fooPost, fooPostReblog])
        Text("hello, world!")
    }
}
