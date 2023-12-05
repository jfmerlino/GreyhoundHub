import SwiftUI

struct AccountView: View {
    @Binding var showingSheet: Bool
    @Binding var loggedIn: Bool
    @Binding var username: String
    @Binding var defaultDropoff: String
    @Binding var ghUsername: String
    @Binding var isWorker: Bool

    @State private var apiService = APIService() // Assuming APIService includes deleteUser

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.mint, .green],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Close button at the top
                HStack {
                    Spacer()
                    Button(action: { showingSheet = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding()
                }

                // List of user details
                VStack(alignment: .leading, spacing: 10) {
                    Text("Username: \(username)")
                        .bold()
                    Text("Grubhub Name: \(ghUsername)")
                    Text("Account Type: \(isWorker ? "Worker" : "Customer")")
                    Text("Preset Dropoff: \(defaultDropoff)")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.8)))
                .padding()

                Spacer()

                // Log out button
                Button(action: {
                    loggedIn = false
                    showingSheet = false
                }) {
                    Text("Log out")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                // Delete account button
                
            }
            .padding(.top)
        }
    }

    func deleteUser() {
        apiService.deleteUser(username: username) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    loggedIn = false
                    showingSheet = false
                case .failure(let error):
                    print("Error deleting user: \(error.localizedDescription)")
                }
            }
        }
    }
}
