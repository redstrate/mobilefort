import SwiftUI

struct ProfileView: View {
    let username: String
    
    var body: some View {
        VStack {
            Text("Hello, world!")
        }.navigationBarTitle(username + "'s Feed")
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
