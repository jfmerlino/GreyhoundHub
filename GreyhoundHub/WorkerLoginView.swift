import SwiftUI

struct WorkerLoginView: View {
    @Binding var username: String
    @State private var password = ""
    @State private var isCreatingAccount = false
    @State private var loginError: String? = nil
    @Binding var isLoggedIn: Bool
    @Binding var showingLoginSheet: Bool
    @Binding var worker: Bool
    

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
                    APIService().getUser(by: username) { result in
                        switch result {
                        case .success(let user):
                            if let userPassword = user["password"] as? String, userPassword == password, let isWorker = user["isWorker"] as? Bool, isWorker == true{
                                isLoggedIn = true
                                worker = true
                                showingLoginSheet = false
                            } else {
                                self.loginError = "Invalid username or password"
                            }
                        case .failure(_):
                            self.loginError = "User not found"
                        }
                    }
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
        }
    }
}
