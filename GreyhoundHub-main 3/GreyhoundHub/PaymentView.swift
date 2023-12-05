//
//  PaymentView.swift
//  GreyhoundHub
//
//  Created by Alex Kristian on 12/4/23.
//

import Foundation
import SwiftUI

struct PaymentView: View {
    @State private var isPaymentSuccessful = false
    @Binding var isShowingPaymentView: Bool
   
    var body: some View {
        VStack {
            if isPaymentSuccessful {
                Text("Payment Successful!")
            } else {
                Button("Pay with Apple Pay") {
                    // Simulate payment processing
                    simulatePayment()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
    }
   
    func simulatePayment() {
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Update state to simulate success
            self.isPaymentSuccessful = true
        }
    }
}
