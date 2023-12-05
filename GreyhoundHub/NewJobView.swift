import SwiftUI

// UserData struct remains the same
struct UserData: Identifiable {
    let id = UUID()
    let ghName: String
    let dropoff: String
    let isWorker: Bool
    let username: String
    let password: String
    let currOrder: String?
}

// UserDetailsView now takes an array of String
struct UserDetailsView: View {
    var userDetails: [String]
    var body: some View {
        VStack {
            Text("Order Details")
                .font(.title)
            List(userDetails, id: \.self) { detail in
                Text(detail)
            }
        }
    }
}

// NewJobView is updated to split the currOrder string
struct NewJobView: View {
    @State private var apiService = APIService()
    @Binding var showingSheet: Bool
    @State var users = [UserData]()
    @State private var userDetails: [String] = []
    @State private var showUserDetails = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.mint, .green],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button(action: { showingSheet = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding()
                }

                ScrollView {
                    ForEach(users.filter { $0.currOrder != nil }, id: \.id) { user in
                        Button(action: {
                            if let currOrder = user.currOrder {
                                self.userDetails = currOrder.components(separatedBy: ", ").filter { !$0.isEmpty }
                            }
                            self.showUserDetails = true
                        }) {
                            Text(user.username) // Display the user's username
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .sheet(isPresented: $showUserDetails, onDismiss: {
            //self.userDetails = []
            MapView(dropOffPoint: userDetails, dropOffLat: 0.0, dropOffLong: 0.0)
        }) {
            UserDetailsView(userDetails: self.userDetails)
        }
        .onAppear {
            apiService.getAllUsers { result in
                switch result {
                case .success(let fetchedUsers):
                    self.users = fetchedUsers.map { userDataDict in
                        UserData(
                            ghName: userDataDict["ghName"] as? String ?? "",
                            dropoff: userDataDict["dropoff"] as? String ?? "",
                            isWorker: userDataDict["isWorker"] as? Bool ?? false,
                            username: userDataDict["username"] as? String ?? "",
                            password: userDataDict["password"] as? String ?? "",
                            currOrder: userDataDict["currOrder"] as? String
                        )
                    }
                case .failure(let error):
                    print("Error fetching users: \(error)")
                }
            }
        }
    }
}
