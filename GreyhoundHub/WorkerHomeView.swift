import SwiftUI

struct WorkerHomeView: View {
    
    @State private var isShowingAccountSheet = false
    @Binding var isLoggedIn: Bool
    @Binding var username: String
    
    
    var body: some View{
        ZStack{
            LinearGradient(
                colors: [.mint, .green],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        isShowingAccountSheet = true
                    }) {
                        Text("Account")
                            .foregroundColor(.black)
                            .padding()
                    }
                    .sheet(isPresented: $isShowingAccountSheet) {
                        AccountView(showingSheet: $isShowingAccountSheet, loggedIn: $isLoggedIn,
                                    username: $username)
                    }
                }
                Text("GreyhoundGrub")
                    .font(.system(size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                HStack{
                    Button(action: {
                        //Go to current order view
                    }) {
                        Text("Current Job")
                            .foregroundColor(.mint)
                            .font(.largeTitle)
                            .bold()
                            .padding()
                            .frame(minHeight: 120)
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        //Go to new order view
                    }) {
                        Text("Select New Job")
                            .foregroundColor(.mint)
                            .font(.largeTitle)
                            .bold()
                            .padding()
                            .frame(minHeight: 120)
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                    
                }
                Spacer()
            }
        }
    }
}
