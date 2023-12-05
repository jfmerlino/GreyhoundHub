import SwiftUI

struct UserData: Identifiable {
    let id = UUID()
    let ghName: String
    let dropoff: String
    let isWorker: Bool
    let username: String
    let password: String
    let currOrder: String?
}

struct NewJobView: View {
    @State private var apiService = APIService()
    @Binding var showingSheet: Bool
    @State var users = [UserData]()

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
                Spacer()

                // Displaying each UserData separately
                ForEach(users) { user in
                    DebugTextView(userDescription: "\(user.username): \(user.currOrder)")
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            apiService.getAllUsers { result in
                switch result {
                case .success(let fetchedUsers):
                    users = fetchedUsers.map { userDataDict in
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
                    // Handle the error
                    print("Error fetching users: \(error)")
                }
            }
        }
    }
}

struct DebugTextView: View {
    var userDescription: String

    var body: some View {
        Text(userDescription)
    }
}
