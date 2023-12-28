//
//  HomePage.swift
//  ShiftSync
//
//  Created by Nischal Niroula on 27/12/2023.
//

import SwiftUI

struct HomePage: View {
    @State private var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                
                ProfileView() // Your Profile view
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(0)
                        ManagerHomePage()
                            .tabItem {
                                Label("Home", systemImage: "house.fill")
                            }
                            .tag(1)

                        SettingsView() // Your Settings view
                            .tabItem {
                                Label("Settings", systemImage: "gearshape.fill")
                            }
                            .tag(2)

                       
                    }
                    .toolbarBackground(lightGreenColor, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
        }
        .accentColor(buttonGreenColor)
                
    }
}

#Preview {
    HomePage()
}
