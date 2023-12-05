import SwiftUI
import CoreLocation

struct WorkerHomeView: View {
    
    @State private var isShowingAccountSheet = false
    @State private var isShowingMap = false
    @Binding var isLoggedIn: Bool
    @Binding var username: String
    @Binding var defaultDropoff: String
    @Binding var ghUsername: String
    @Binding var isWorker: Bool
    @State var locationName: String

    
    
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
                        isShowingMap = true
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
                    .sheet(isPresented: $isShowingMap) {
                        MapView(dropOffPoint: $locationName, dropOffLat: 0.0, dropOffLong: 0.0)
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
