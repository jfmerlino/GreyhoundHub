import SwiftUI

struct CreateIggysView: View {
    @Binding var showingSheet: Bool
    @State var grubhubNumber = ""
    @State var grubhubName = ""
    @State var beingPickedUp = ""
    @State var locationDropoff = ""
    @State var extra = ""
    
    @State private var storedInputs: [String] = [] // Storing inputs in a list
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.mint, .green],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    closeButton
                    titleView
                    
                    Spacer(minLength: 20)
                    
                    textFieldView("Please enter your Grubhub Number:", placeholder: "Grubhub Number", text: $grubhubNumber)
                    textFieldView("Please enter your Grubhub name for extra security purposes:", placeholder: "Name", text: $grubhubName)
                    textFieldView("Please enter what is being picked up:", placeholder: "Pickup", text: $beingPickedUp)
                    textFieldView("Please enter dropoff location:", placeholder: "Location", text: $locationDropoff)
                    textFieldView("Additional comments or requests:", placeholder: "Extras", text: $extra)
                }
                .padding()
            }
        }
        .onDisappear {
            // Saving inputs to UserDefaults when view disappears
            storeInputs()
        }
        .onAppear {
            // Loading inputs from UserDefaults when view appears
            loadInputs()
        }
    }
    
    var closeButton: some View {
        HStack {
            Spacer()
            Button("X") {
                showingSheet = false
            }
            .foregroundColor(.red)
            .padding()
            .font(.largeTitle)
            .bold()
        }
    }
    
    var titleView: some View {
        Text("Iggys")
            .font(.system(size: 48))
            .fontWeight(.bold)
            .foregroundColor(.white)
    }
    
    func textFieldView(_ title: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            TextField(placeholder, text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    func storeInputs() {
        storedInputs = [grubhubNumber, grubhubName, beingPickedUp, locationDropoff, extra]
        UserDefaults.standard.set(storedInputs, forKey: "IggysStoredInputsKey")
    }
    
    func loadInputs() {
        if let inputs = UserDefaults.standard.stringArray(forKey: "IggysStoredInputsKey") {
            storedInputs = inputs
            if storedInputs.count == 5 { // Assuming 5 inputs
                grubhubNumber = storedInputs[0]
                grubhubName = storedInputs[1]
                beingPickedUp = storedInputs[2]
                locationDropoff = storedInputs[3]
                extra = storedInputs[4]
            }
        }
    }
}

