import SwiftUI

struct StartView: View{
    
    @State private var isLoginViewPresented = false
    @State private var isWorkerLoginViewPresented = false
    @Binding var isLoggedIn: Bool
    @Binding var username: String
    @Binding var defaultDropoff: String
    @Binding var ghUsername: String
    @Binding var isWorker: Bool
    
    
    var body: some View{
        
        ZStack {
            LinearGradient(
                colors: [.mint, .green],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Text("GreyhoundGrub")
                    .font(.system(size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        isWorkerLoginViewPresented = true
                    }) {
                        Text("Worker")
                            .foregroundColor(.mint)
                            .font(.largeTitle)
                            .bold()
                            .padding()
                            .frame(minHeight: 120)
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $isWorkerLoginViewPresented) {
                        WorkerLoginView(username: $username, isLoggedIn: $isLoggedIn, showingLoginSheet: $isWorkerLoginViewPresented, worker: $isWorker)
                    }
                    
                    Button(action: {
                        isLoginViewPresented = true
                    }) {
                        Text("Student")
                            .foregroundColor(.mint)
                            .font(.largeTitle)
                            .bold()
                            .padding()
                            .frame(minHeight: 120)
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $isLoginViewPresented) {
                        LoginView(username: $username, defaultDropoff: $defaultDropoff, ghUsername: $ghUsername, isLoggedIn: $isLoggedIn, showingLoginSheet: $isLoginViewPresented, isWorker: $isWorker)
                    }

                }
                
                Spacer()
            }
        }
    }
}
