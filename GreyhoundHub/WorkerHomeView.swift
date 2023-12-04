import SwiftUI

struct WorkerHomeView: View {
    
    @State private var isShowingAccountSheet = false
    @State private var showMapView = false
    @Binding var isLoggedIn: Bool
    @Binding var username: String
    @Binding var defaultDropoff: String
    @Binding var ghUsername: String
    @Binding var isWorker: Bool

    
    
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
                                    username: $username, defaultDropoff: $defaultDropoff, ghUsername: $ghUsername, isWorker: $isWorker)
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
                        showMapView = true
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
                    .fullScreenCover(isPresented: $showMapView) {
                        MapView()
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
