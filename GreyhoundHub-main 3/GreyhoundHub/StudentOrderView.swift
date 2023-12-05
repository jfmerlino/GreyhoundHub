//
//  StudentOrderView.swift
//  GreyhoundHub
//
//  Created by Alex Kristian on 12/4/23.
//

import Foundation
import SwiftUI

struct StudentOrderView: View {
    @State var orderStatus: String = ""
    @State var fromLoc : String = ""
    @State var orderNum : String = ""
    @State var grubName : String = ""
    @State var whatOrdered : String = ""
    @State var toLoc : String = ""
    
    @Binding var isShowingOrdering: Bool
    @Binding var user: String
    @State var users = [UserData]()
    @State private var userDetails: [String] = []
    @State private var apiService = APIService()
    
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.mint, .green],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            .ignoresSafeArea()
            if(hasOrder(userDetails: userDetails)){
                VStack {
                    
                    if (orderStatus == "New") {
                        Text("Order #" + orderNum)
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                        Text("Waiting for a worker to pick up your order...")
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                        Text("You Ordered: " + whatOrdered)
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                        Text("\(fromLoc) -> \(orderNum)")
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                        
                        
                        Button("Refresh"){
                            userDetails = []
                            apiService.getAllUsers { result in
                                switch result {
                                case .success(let fetchedUsers):
                                    self.users = fetchedUsers.map { userDataDict in
                                        UserData(
                                            ghName: userDataDict["ghName"] as? String ?? "",
                                            dropoff: userDataDict["dropoff"] as? String ?? "",
                                            isWorker: userDataDict["isWorker"] as? Bool ?? false,
                                            username: userDataDict["username"] as? String ?? "",
                                            password: userDataDict["password"] as? String ?? "",
                                            currOrder: userDataDict["currOrder"] as? String
                                        )
                                    }
                                    
                                    for person in self.users.filter({ $0.currOrder != nil }) {
                                        if person.username == self.user, let currOrder = person.currOrder {
                                            self.userDetails = currOrder.components(separatedBy: ", ").filter { !$0.isEmpty }
                                            orderStatus = userDetails[0]
                                            fromLoc = userDetails[1]
                                            //order num
                                            orderNum = userDetails[2]
                                            //grub nam
                                            grubName = userDetails[3]
                                            //what ordered
                                            whatOrdered = userDetails[4]
                                            //location to
                                            toLoc = userDetails[5]
                                            //notes
                                        }
                                    }
                                    
                                case .failure(let error):
                                    print("Error fetching users: \(error)")
                                }
                            }
                        }
                        
                    }
                    else{
                        Text("No Order To View")
                        Button("Refresh"){
                            userDetails = []
                            apiService.getAllUsers { result in
                                switch result {
                                case .success(let fetchedUsers):
                                    self.users = fetchedUsers.map { userDataDict in
                                        UserData(
                                            ghName: userDataDict["ghName"] as? String ?? "",
                                            dropoff: userDataDict["dropoff"] as? String ?? "",
                                            isWorker: userDataDict["isWorker"] as? Bool ?? false,
                                            username: userDataDict["username"] as? String ?? "",
                                            password: userDataDict["password"] as? String ?? "",
                                            currOrder: userDataDict["currOrder"] as? String
                                        )
                                    }
                                    
                                    for person in self.users.filter({ $0.currOrder != nil }) {
                                        if person.username == self.user, let currOrder = person.currOrder {
                                            self.userDetails = currOrder.components(separatedBy: ", ").filter { !$0.isEmpty }
                                            orderStatus = userDetails[0]
                                            fromLoc = userDetails[1]
                                            //order num
                                            orderNum = userDetails[2]
                                            //grub nam
                                            grubName = userDetails[3]
                                            //what ordered
                                            whatOrdered = userDetails[4]
                                            //location to
                                            toLoc = userDetails[5]
                                            //notes
                                        }
                                    }
                                    
                                case .failure(let error):
                                    print("Error fetching users: \(error)")
                                }
                            }
                        }
                    }
                    
                }
            }
            else{
                Text("No Order To View")
                Button("Refresh"){
                    userDetails = []
                    apiService.getAllUsers { result in
                        switch result {
                        case .success(let fetchedUsers):
                            self.users = fetchedUsers.map { userDataDict in
                                UserData(
                                    ghName: userDataDict["ghName"] as? String ?? "",
                                    dropoff: userDataDict["dropoff"] as? String ?? "",
                                    isWorker: userDataDict["isWorker"] as? Bool ?? false,
                                    username: userDataDict["username"] as? String ?? "",
                                    password: userDataDict["password"] as? String ?? "",
                                    currOrder: userDataDict["currOrder"] as? String
                                )
                            }
                            
                            for person in self.users.filter({ $0.currOrder != nil }) {
                                if person.username == self.user, let currOrder = person.currOrder {
                                    self.userDetails = currOrder.components(separatedBy: ", ").filter { !$0.isEmpty }
                                    orderStatus = userDetails[0]
                                    fromLoc = userDetails[1]
                                    //order num
                                    orderNum = userDetails[2]
                                    //grub nam
                                    grubName = userDetails[3]
                                    //what ordered
                                    whatOrdered = userDetails[4]
                                    //location to
                                    toLoc = userDetails[5]
                                    //notes
                                }
                            }
                            
                        case .failure(let error):
                            print("Error fetching users: \(error)")
                        }
                    }
                }
            }
            
        }
                .onAppear(perform: {
                    userDetails = []
                    apiService.getAllUsers { result in
                        switch result {
                        case .success(let fetchedUsers):
                            self.users = fetchedUsers.map { userDataDict in
                                UserData(
                                    ghName: userDataDict["ghName"] as? String ?? "",
                                    dropoff: userDataDict["dropoff"] as? String ?? "",
                                    isWorker: userDataDict["isWorker"] as? Bool ?? false,
                                    username: userDataDict["username"] as? String ?? "",
                                    password: userDataDict["password"] as? String ?? "",
                                    currOrder: userDataDict["currOrder"] as? String
                                )
                            }
                            
                            for person in self.users.filter({ $0.currOrder != nil }) {
                                if person.username == self.user, let currOrder = person.currOrder {
                                    self.userDetails = currOrder.components(separatedBy: ", ").filter { !$0.isEmpty }
                                    orderStatus = userDetails[0]
                                    fromLoc = userDetails[1]
                                    //order num
                                    orderNum = userDetails[2]
                                    //grub nam
                                    grubName = userDetails[3]
                                    //what ordered
                                    whatOrdered = userDetails[4]
                                    //location to
                                    //toLoc = userDetails[5]
                                    //notes
                                }
                            }
                            
                        case .failure(let error):
                            print("Error fetching users: \(error)")
                        }
                    }
                })
            
    }
}
        func hasOrder(userDetails: [String])-> Bool{
            if(userDetails.isEmpty){
                return false
            }
            
            return true
        }
        


var titleView: some View {
    Text("Order Status")
        .font(.system(size: 48))
        .fontWeight(.bold)
        .foregroundColor(.white)
}


