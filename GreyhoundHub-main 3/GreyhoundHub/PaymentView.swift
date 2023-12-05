//
//  PaymentView.swift
//  GreyhoundHub
//
//  Created by Alex Kristian on 12/5/23.
//

import Foundation
import SwiftUI

struct PaymentView: View {
    @State private var isPaymentSuccessful = false
    @Binding var isShowingPaymentView: Bool
    @Binding var isShowingChoices: Bool
   
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.mint, .green],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            .ignoresSafeArea()
            VStack {
                if isPaymentSuccessful {
                    Text("Payment Successful!")
                } else {
                    Button("Pay with Apple Pay") {
                        // Simulate payment processing
                        simulatePayment()
                        isShowingChoices = false
                        isShowingPaymentView = false
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
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
