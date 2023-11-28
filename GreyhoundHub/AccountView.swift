import SwiftUI

struct AccountView: View{
    @Binding var showingSheet: Bool
    @Binding var loggedIn: Bool
    @Binding var username: String
    var body: some View{
        ZStack {
            LinearGradient(
                colors: [.mint, .green],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack{
                HStack{
                    Spacer()
                    Button("X"){
                        showingSheet = false
                    }
                    .foregroundColor(Color.red)
                    .padding()
                    .font(.largeTitle)
                    .bold()
                }
                List{
                    Text("Username: \(username)")
                    Text("Grubhub Name: ")
                    Text("Account Type: ")
                    Text("Preset Dropoff: ")
                }
                .scrollContentBackground(.hidden)
                
                Spacer()
                Button(action: {
                    loggedIn = false
                    showingSheet = false
                }) {
                    Text("Log out")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                
            }
            
        }
    }
}
