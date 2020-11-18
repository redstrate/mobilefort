import SwiftUI

struct MainView: View {
    @State private var username: String = ""
    
    var body: some View {
        VStack {
            ProfileView(username: "redstrate")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
