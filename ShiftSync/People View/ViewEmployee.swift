//
//  ViewEmployee.swift
//  ShiftSync
//
//  Created by Nischal Niroula on 28/12/2023.
//
import SwiftUI

struct ViewEmployee: View {

@Environment(\.presentationMode) var presentationMode
@State private var searchText = ""

var body: some View {
    NavigationView {
        ZStack {
            
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            VStack{
                // Search Bar
                VStack {
                    HStack {
                        VStack {
                            TextField("", text: $searchText)
                                .keyboardType(.emailAddress)
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                                .foregroundColor(.white)
                                .bold()
                                .placeholder(when: searchText.isEmpty){
                                    Text("Employee Name")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                }
                            
                        }
                        Spacer()
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.yellow)
                        
                        
                    }
                    
                    
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
                .padding()
                
                Spacer()
                
                //Employee List Goes here
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
                                Text("View Employee")
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
    ViewEmployee()
}
