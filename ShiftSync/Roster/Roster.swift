//
//  Roster.swift
//  ShiftSync
//
//  Created by Nischal Niroula on 30/12/2023.
//

import SwiftUI

struct Roster: View {
    @State private var showingViewRosterView = false
    @State private var showingAddRosterView = false
    @State private var viewEmployeeOffset = UIScreen.main.bounds.width
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Button(action: {
                            showingViewRosterView = true
                                        }) {
                                            HStack {
                                                Text("View Roster")
                                                    .foregroundColor(.white)
                                                    .bold()
                                                Spacer()
                                                Image(systemName: "calendar")
                                                    .font(.title)
                                                    .foregroundColor(appWhiteColor)
                                                
                                            }
                                            .padding()
                                            .background(lightGreenColor)
                                            .cornerRadius(10)
                                            .padding(.horizontal)
                                            .padding(.vertical, 10)
                                            .shadow(color: .black, radius: 2, x: 0, y: 4)
                                        }
                                        .fullScreenCover(isPresented: $showingViewRosterView) {
                                            ViewRoster(rosterViewModel: RosterViewModel())
                                        }
                    
                    Button(action: {
                            showingAddRosterView = true
                                        }) {
                                            HStack {
                                                Text("Add Roster")
                                                    .foregroundColor(.white)
                                                    .bold()
                                                Spacer()
                                                Image(systemName: "calendar.badge.plus")
                                                    .font(.title)
                                                    .foregroundColor(appWhiteColor)
                                                
                                            }
                                            .padding()
                                            .background(lightGreenColor)
                                            .cornerRadius(10)
                                            .padding(.horizontal)
                                            .padding(.vertical, 10)
                                            .shadow(color: .black, radius: 2, x: 0, y: 4)
                                        }
                                        .fullScreenCover(isPresented: $showingAddRosterView) {
                                            AddRosterView(rosterViewModel: RosterViewModel())
                                        }
                    
                    Spacer()
                }
                
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        HStack {
                                            Image(systemName: "chevron.left")
                                                .foregroundColor(buttonGreenColor)
                                            Text("Back")
                                                .foregroundColor(buttonGreenColor)
                                                .bold()
                                        }
                                    }
                                }
                
                
                ToolbarItem(placement: .principal) {
                                HStack {
                                    Text("Roster")
                                        .font(.system(size: 20))
                                        .foregroundColor(buttonGreenColor)
                                        .bold()
                                }
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    Roster()
}
