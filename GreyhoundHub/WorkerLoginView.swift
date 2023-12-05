import SwiftUI

struct WorkerLoginView: View {
    @Binding var username: String
    @State private var password = ""
    @State private var isCreatingAccount = false
    @State private var loginError: String? = nil
    @Binding var isLoggedIn: Bool
    @Binding var showingLoginSheet: Bool
    @Binding var worker: Bool
    
    @State private var isLoading = false // New state for loading screen

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.green, .mint],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Text("Login Page")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                Spacer()
                
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Spacer()

                if let error = loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: {
                    loginAction()
                }) {
                    Text("Login")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .frame(maxWidth: 300)
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
                
                Button(action: {
                    isCreatingAccount = true
                }) {
                    Text("Create New Account")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isCreatingAccount) {
                    CreateAccountView(creatingAccount: $isCreatingAccount)
                }
            }
            
            // Loading screen
            if isLoading {
                Color.white.opacity(0.7) // Example loading screen color
                    .ignoresSafeArea()
                    .overlay(
                        Text("Logging in...")
                            .font(.headline)
                            .foregroundColor(.black)
                    )
            }
        }
    }
    
    func loginAction() {
        // Show loading screen
        isLoading = true
        
        // Perform login actions...
        // Your login logic here...
        // Upon completion, hide loading screen
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false // Simulating login delay with DispatchQueue
            // Example of successful login
            isLoggedIn = true
            worker = true
            showingLoginSheet = false
        }
    }
}

