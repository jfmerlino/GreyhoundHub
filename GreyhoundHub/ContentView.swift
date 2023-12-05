import SwiftUI
import CoreLocation
import Foundation


struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var username: String = ""
    @State private var defaultDropoff: String = ""
    @State private var ghUsername: String = ""
    @State private var isWorker = false
    

    
    var body: some View {
        if(isLoggedIn && !isWorker){
            CreateBypassView(isLoggedIn: $isLoggedIn, username: $username, defaultDropoff: $defaultDropoff, ghUsername: $ghUsername, isWorker: $isWorker)
        }
        else if (isLoggedIn && isWorker){
            WorkerHomeView(isLoggedIn: $isLoggedIn, username: $username, defaultDropoff: $defaultDropoff, ghUsername: $ghUsername, isWorker: $isWorker, locationName: "loyola")
        }
        else{
            StartView(isLoggedIn: $isLoggedIn, username: $username, defaultDropoff: $defaultDropoff, ghUsername: $ghUsername, isWorker: $isWorker)
        }
    }
}


class PostViewModel: ObservableObject {
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
