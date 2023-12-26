//
//  ShiftSyncApp.swift
//  ShiftSync
//
//  Created by Nischal Niroula on 24/12/2023.
//

import SwiftUI
import Firebase

@main
struct ShiftSyncApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
       
        WindowGroup {
            ContentView()
        }
    }
}
