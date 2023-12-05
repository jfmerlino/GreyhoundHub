import SwiftUI

struct CreateBoulderView: View {
    @Binding var showingSheet: Bool
    @Binding var username: String
    @State var grubhubNumber = ""
    @State var grubhubName = ""
    @State var beingPickedUp = ""
    @State var locationDropoff = ""
    @State var extra = ""
    @State var orderStatus = "New"
    @State var name = "Boulder"
    @State var showingPayment = false

    
    @State private var storedInputs: [String] = [] // Storing inputs in a list
    @State private var apiService = APIService() // Instance of APIService
    @State private var updateResult: Result<Void, Error>? = nil
    @State var locationDropoffIndex = 0
    
    let locations = ["Ahern Hall", "Avila Hall", "Bellarmine Hall", "Butler Hall", "Campion Hall", "Claver Hall", "Dorothy Day Hall", "Fernandez Center", "Fitness and Aquatics Center", "Hammerman Hall", "Hopkins Court", "Humanities Center", "Knott Hall", "Lange Court", "Loyola Notre Dame Library", "Maryland Hall", "McAuley Hall", "Newman Towers", "Rahner Village", "Sellinger School of Business", "Thea Bowman Hall"]
    
    @State private var isLoading = false // New state for loading screen

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.mint, .green],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    closeButton
                    titleView
                    
                    Spacer(minLength: 5)
                    
                    textFieldView("Please enter your Grubhub Number:", placeholder: "Grubhub Number", text: $grubhubNumber)
                    textFieldView("Please enter your Grubhub name for extra security purposes:", placeholder: "Name", text: $grubhubName)
                    textFieldView("Please enter what is being picked up:", placeholder: "Pickup", text: $beingPickedUp)
                    textFieldView("Additional comments or requests:", placeholder: "Extras", text: $extra)

                    Section(header: Text("Dropoff Location").font(.headline)) {
                        Picker(selection: $locationDropoffIndex, label: Text("Please choose dropoff location").foregroundColor(.green)) {
                            ForEach(0..<locations.count, id: \.self) { index in
                                Text(locations[index]).tag(index)
                            }
                        }
                        .pickerStyle(InlinePickerStyle())
                        .frame(width: 300, height: 100)
                        .background(Color.white.opacity(0.1)) // Soft background color
                        .cornerRadius(8)
                        .padding()
                    }
                    
                    // Button to update order
                    Button("Update Order") {
                        updateOrderForUser()
                        showingPayment.toggle()
                    }
                    .buttonStyle(FilledButton())
                    .padding()
                    .disabled(grubhubNumber.count < 1 || grubhubName.count < 1 || beingPickedUp.count < 1)
                }
                .padding()
            }
        }
        .alert(isPresented: .constant(updateResult != nil), content: {
            Alert(title: Text(updateResultTitle), message: Text(updateResultMessage), dismissButton: .default(Text("OK")))
        })
        .onDisappear {
            // Saving inputs to UserDefaults when view disappears
            storeInputs()
        }
        .onAppear {
            // Loading inputs from UserDefaults when view appears
            loadInputs()
        }
        .overlay(
            Group {
                if isLoading {
                    Color.white.opacity(0.7) // Example loading screen color
                        .ignoresSafeArea()
                        .overlay(
                            Text("Loading...")
                                .font(.headline)
                                .foregroundColor(.black)
                        )
                }
            }
        )
        .sheet(isPresented: $showingPayment){
            PaymentView(isShowingPaymentView: $showingPayment, isShowingChoices: $showingSheet)
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
        Text("Boulder")
            .font(.system(size: 35))
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
    
    func updateOrderForUser() {
        storeInputs()
        // Show loading screen
        isLoading = true

        // Combine the inputs into a single string, or use a more structured approach if necessary
        let orderDetails = storedInputs.joined(separator: ", ")

        // Assuming username is available, replace 'yourUsername' with actual username
        apiService.updateOrder(username: username, newOrder: orderDetails) { result in
            // Hide loading screen when process completes
            isLoading = false
            self.updateResult = result
        }
    }

    var updateResultTitle: String {
        switch updateResult {
        case .success:
            return "Success"
        case .failure:
            return "Error"
        case .none:
            return ""
        }
    }

    var updateResultMessage: String {
        switch updateResult {
        case .success:
            // Joining the storedInputs array elements to create a string representation
            let inputsString = storedInputs.joined(separator: ", ")
            return "Order updated successfully with details: \(inputsString)"
        case .failure(let error):
            return "Failed to update order: \(error.localizedDescription)"
        case .none:
            return ""
        }
    }

    func storeInputs() {
        storedInputs = [orderStatus, name, grubhubNumber, grubhubName, beingPickedUp, locations[locationDropoffIndex], extra]
        UserDefaults.standard.set(storedInputs, forKey: "StoredInputsKey")
    }
    
    func loadInputs() {
        if let inputs = UserDefaults.standard.stringArray(forKey: "StoredInputsKey") {
            storedInputs = inputs
            if storedInputs.count == 7 { // Assuming 5 inputs
                orderStatus = storedInputs[0]
                grubhubNumber = storedInputs[2]
                grubhubName = storedInputs[3]
                beingPickedUp = storedInputs[4]
                locationDropoff = storedInputs[5]
                extra = storedInputs[6]
            }
        }
    }
}



struct FilledButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
