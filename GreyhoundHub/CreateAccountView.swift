import SwiftUI

struct CreateAccountView: View {
    @State private var newUsername = ""
    @State private var newPassword = ""
    @State private var accountCreationStatus: String? = nil
    @State private var accountCreationSuccessful = false
    @Binding var creatingAccount: Bool
    @State var isWorker = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.mint, .green],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                TextField("Username", text: $newUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Toggle("Is Worker", isOn: $isWorker)
                    .padding()

                if let status = accountCreationStatus {
                    Text(status)
                        .foregroundColor(accountCreationSuccessful ? .green : .red)
                        .padding()
                }
                
                Button(action: {
                    APIService().createUser(isWorker: isWorker, username: newUsername, password: newPassword) { result in
                        switch result {
                        case .success:
                            accountCreationStatus = "Account created successfully!"
                            accountCreationSuccessful = true
                            creatingAccount = false
                        case .failure(_):
                            accountCreationStatus = "Created"
                            accountCreationSuccessful = false
                            creatingAccount = false
                        }
                    }
                }) {
                    Text("Create Account")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
    }
}
