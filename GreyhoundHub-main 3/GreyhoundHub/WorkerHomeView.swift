import SwiftUI
import CoreLocation

struct WorkerHomeView: View {
    
    @State private var isShowingAccountSheet = false
    @State var isShowingMap = false
    @State private var showingNewJobSheet = false
    @State private var userDetails = [String]()
    @Binding var isLoggedIn: Bool
    @Binding var username: String
    @Binding var defaultDropoff: String
    @Binding var ghUsername: String
    @Binding var isWorker: Bool
    @State var locationName: String
    @Binding var orderName: String

    
    
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
                        MapView(dropOffPoint: $userDetails, dropOffLat: 0.0, dropOffLong: 0.0, orderName: $orderName, isShowingMap: $isShowingMap)
                    }
                    

                    
                    Button(action: {
                        showingNewJobSheet.toggle()
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
                    .sheet(isPresented: $showingNewJobSheet) {
                        NewJobView(showingSheet: $showingNewJobSheet, showingMapSheet: $isShowingMap, userDetails: $userDetails, orderName: $orderName)
                    }
                }
                Spacer()
            }
        }
    }
}

