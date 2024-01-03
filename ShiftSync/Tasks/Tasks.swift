//
//  Tasks.swift
//  ShiftSync
//
//  Created by Nischal Niroula on 30/12/2023.
//

import SwiftUI

struct Tasks: View {
    @State private var showingViewTasksView = false
    @State private var showingAddTasksView = false
    @State private var viewEmployeeOffset = UIScreen.main.bounds.width
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                // Set the background color for the entire screen
                backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Button(action: {
                            showingViewTasksView = true
                                        }) {
                                            HStack {
                                                Text("View Tasks")
                                                    .foregroundColor(.white)
                                                    .bold()
                                                Spacer()
                                                Image(systemName: "note.text")
                                                    .font(.title)
                                                    .foregroundColor(appWhiteColor)
                                                
                                            }
                                            .padding()
                                            .background(lightGreenColor)
                                            .cornerRadius(10)
                                            .padding(.horizontal)
                                            .padding(.vertical, 10)
                                        }
                                        .fullScreenCover(isPresented: $showingViewTasksView) {
                                            ViewTasks()
                                        }
                    
                    Button(action: {
                            showingAddTasksView = true
                                        }) {
                                            HStack {
                                                Text("Add Tasks")
                                                    .foregroundColor(.white)
                                                    .bold()
                                                Spacer()
                                                Image(systemName: "note.text.badge.plus")
                                                    .font(.title)
                                                    .foregroundColor(appWhiteColor)
                                                
                                            }
                                            .padding()
                                            .background(lightGreenColor)
                                            .cornerRadius(10)
                                            .padding(.horizontal)
                                            .padding(.vertical, 10)
                                        }
                                        .fullScreenCover(isPresented: $showingAddTasksView) {
                                            AddTasks()
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
                                    Text("Tasks")
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
    Tasks()
}
