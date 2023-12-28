//
//  EmployeeHomePage.swift
//  ShiftSync
//
//  Created by Nischal Niroula on 24/12/2023.
//

import SwiftUI

struct EmployeeHomePage: View {
    @State private var currentTime = Date()
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short // for hour and minute; e.g., '9:41 AM'
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy" // e.g., '25 December 2023'
        return formatter
    }()
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect() // Update every minute

    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()

                VStack(spacing: 5) {
                    // Time and Date
                    Text(timeFormatter.string(from: currentTime))
                        .font(.custom("Poppins-Black", size: 48))
                        .foregroundColor(appWhiteColor)
                    
                    Text(dateFormatter.string(from: currentTime))
                        .font(.custom("Poppins-Medium", size: 16))
                        .foregroundColor(appWhiteColor)

                    
                    Text ("5 Hours until next shift")
                        .font(.custom("Poppins-Medium", size: 20))
                        .foregroundColor(appWhiteColor)
                        .padding(.top, 10)
                    
                    Rectangle()
                        .fill(buttonGreenColor)
                        .frame(height: 2)
                    
                    Spacer()
                    
                    // Menu Grids
                    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
                                   
                    LazyVGrid(columns: gridItems, spacing: 20) {
                        GridMenuButton(title: "Roster", systemImageName: "suitcase.fill")
                        GridMenuButton(title: "Tasks", systemImageName: "list.bullet.rectangle.portrait.fill")
                        GridMenuButton(title: "Unavailability", systemImageName: "calendar.badge.exclamationmark")
                        
                    }
                    .padding(.bottom, 100)
                }
                .onReceive(timer) { input in
                    currentTime = input
                }
                .padding()
            }
            .navigationBarItems(
                leading: Image(systemName: "bell.fill")
                    .foregroundColor(buttonGreenColor)
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    EmployeeHomePage()
}
