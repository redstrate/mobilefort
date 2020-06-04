import SwiftUI

struct ProfileView: View {
    var body: some View {
        Text("Hello, world!")
    }
}

struct MainView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: ProfileView()) {
                Text("Show Feed")
            }
        }
    }
}
