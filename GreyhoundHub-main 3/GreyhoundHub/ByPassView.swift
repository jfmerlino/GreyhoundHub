import SwiftUI

struct CreateBypassView: View {
    @State private var orderingIggy = false
    @State private var orderingBoulder = false
    @State private var orderingGreenGrey = false
    @State private var orderingStarbucks = false
    @State private var isShowingAccountSheet = false
    @State private var showCurrentOrder = false
    @Binding var isLoggedIn: Bool
    @Binding var username: String
    @Binding var defaultDropoff: String
    @Binding var ghUsername: String
    @Binding var isWorker: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.mint, .green],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                topBar
                
                titleView
                
                Spacer(minLength: 50)
                optionButton("View Current Order", isPresented: $showCurrentOrder, view: StudentOrderView(isShowingOrdering: $showCurrentOrder, user: $username))
                optionButton("Iggys", isPresented: $orderingIggy, view: CreateIggysView(showingSheet: $orderingIggy, username: $username))
                optionButton("Boulder", isPresented: $orderingBoulder, view: CreateBoulderView(showingSheet: $orderingBoulder, username: $username))
                optionButton("Green & Grey", isPresented: $orderingGreenGrey, view: CreateGreenGreyView(showingSheet: $orderingGreenGrey, username: $username))
                optionButton("Starbucks", isPresented: $orderingStarbucks, view: CreateStarbucksView(showingSheet: $orderingStarbucks, username: $username))
            }
        }
        .onAppear{
            
        }
    }
    
    var topBar: some View {
        HStack {
            Spacer()
            Button("Account") {
                isShowingAccountSheet = true
            }
            .foregroundColor(.primary)
            .padding()
            .sheet(isPresented: $isShowingAccountSheet) {
                AccountView(showingSheet: $isShowingAccountSheet, loggedIn: $isLoggedIn, username: $username, defaultDropoff: $defaultDropoff, ghUsername: $ghUsername, isWorker: $isWorker)
            }
        }
    }
    
    var titleView: some View {
        VStack {
            Text("GreyhoundGrub")
                .font(.system(size: 48))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Please choose which dining hall you ordered from.")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)
        }
    }
    
    func optionButton(_ title: String, isPresented: Binding<Bool>, view: some View) -> some View {
        Button(title) {
            isPresented.wrappedValue = true
        }
        .foregroundColor(.white)
        .padding()
        .frame(width: 200, height: 40)
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
        .sheet(isPresented: isPresented) { view }
        .padding(.vertical, 10)
    }
}
