import SwiftUI

struct MainView: View {
    @State private var username: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Username", text: $username)
                    .disableAutocorrection(true)
                NavigationLink(destination: ProfileView(username: username)) {
                    Text("Show Feed")
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
