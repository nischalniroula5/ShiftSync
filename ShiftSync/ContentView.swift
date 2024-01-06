//
//  ContentView.swift
//  ShiftSync
//
//  Created by Nischal Niroula on 24/12/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isActive = false

    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            VStack {
                        if isActive {
                            LoginScreen()
                        } else {
                            Image("ShiftSyncLogo")
                        }
                    }
                    .onAppear {
                        // Trigger the transition after 2.5 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
                .edgesIgnoringSafeArea(.all)
        } // Optional: to make it full screen
            }

}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
