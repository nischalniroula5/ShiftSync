//
//  SideMenuTest.swift
//  ShiftSync
//
//  Created by Nischal Niroula on 26/12/2023.
//

import SwiftUI

struct SideMenuTest: View {
    @State private var showSideBar = false
       
       var mainView: some View{
           Text("This is main menu")
          /* Rectangle()
               .foregroundColor(.gray)
               .overlay(Text("Main View"))
               .ignoresSafeArea()
           */
       }
       
       var sideBar: some View{
           Rectangle()
               .foregroundColor(.green)
               .overlay(Text("side bar"))
               .frame(width: 200)
               //.ignoresSafeArea()
       }
       
       var body: some View {
           
           NavigationStack{
               
               ZStack(alignment: .leading) {
                   mainView
                   
                   if showSideBar {
                       sideBar
                           .transition(.move(edge: .leading))
                   }
               }
               
               .toolbar {
                   ToolbarItem(placement: .navigationBarLeading) {
                       Button {
                           withAnimation {
                               showSideBar.toggle()
                           }
                       } label: {
                           Image(systemName: "sidebar.left")
                       }
                       
                   }
               }
           }
       }
   }

#Preview {
    SideMenuTest()
}
