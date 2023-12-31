//
//  LoginScreen.swift
//  ShiftSync
//
//  Created by Nischal Niroula on 24/12/2023.
//

import SwiftUI
import Firebase


//Colors

let appWhiteColor = Color(red: 255 / 255, green: 247 / 255, blue: 214 / 255) //#FFF7D6
let backgroundColor = Color(red: 8 / 255, green: 37 / 255, blue: 59 / 255) // #08253B
let lightGreenColor = Color(red: 11 / 255, green: 48 / 255, blue: 73 / 255) // #0B3049
let buttonGreenColor = Color(red: 33 / 255, green: 135 / 255, blue: 145 / 255) // #218791



struct LoginScreen: View {
    
    
    //Variables
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var selectedRole = "Manager"
    
    @State private var navigateTo: Role?
    
    @State private var navigateToManager = false
    @State private var navigateToEmployee = false
    
    @State private var showAlert = false
        @State private var alertMessage = ""
    
    enum Role {
            case manager, employee
        }
    
    let roles = ["Manager", "Employee"]
    
    var body: some View {
        NavigationView{
            ZStack{
                backgroundColor
                    .ignoresSafeArea()
                // Invisible NavigationLinks
                NavigationLink(destination: ManagerHomePage().navigationBarBackButtonHidden(true), isActive: $navigateToManager) { EmptyView() }
                                NavigationLink(destination: EmployeeHomePage().navigationBarBackButtonHidden(true), isActive: $navigateToEmployee) { EmptyView() }
                
                GeometryReader{ (proxy : GeometryProxy) in
                              VStack(alignment: .trailing) {
                               Image("LoginBgBlob").edgesIgnoringSafeArea(.top)
                              }
                              .frame(width: proxy.size.width, height:proxy.size.height , alignment: .topLeading)
                    }
                    
                VStack{
                    // Role Picker
                    
                    HStack {
                        Text("Choose Role:")
                            .foregroundColor(.white)
                            .bold()
                        Spacer()
                        Picker("Choose Role:", selection: $selectedRole) {
                            Text("Manager").tag("Manager")
                            Text("Employee").tag("Employee")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(.white)
                        .bold()
                    }
                    .padding()
                    .background(lightGreenColor)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Employee ID Field
                    VStack {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.yellow)
                            
                            VStack {
                                TextField("", text: $email)
                                    .keyboardType(.emailAddress)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                                    .foregroundColor(.white)
                                    .bold()
                                    .placeholder(when: email.isEmpty){
                                        Text("Email")
                                            .foregroundColor(.white)
                                            .bold()
                                            .padding(.leading, 16)
                                    }
                                
                            }
                        }
                        
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                    }
                    .padding()
                    
                    //Password Field
                    
                    VStack {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.yellow)
                            
                            if isPasswordVisible {
                                TextField("", text: $password)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                                    .foregroundColor(.white)
                                    .bold()
                                    .placeholder(when: email.isEmpty){
                                        Text("Password")
                                            .foregroundColor(.white)
                                            .bold()
                                            .padding(.leading, 16)
                                    }
                                
                            } else {
                                SecureField("", text: $password)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                                    .bold()
                                    .foregroundColor(.white)
                                    .placeholder(when: email.isEmpty){
                                        Text("Password")
                                            .foregroundColor(.white)
                                            .bold()
                                            .padding(.leading, 16)
                                    }
                            }
                            
                            Button(action: {
                                self.isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(.yellow)
                                    .padding(.trailing, 15)
                            }
                        }
                        
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                    }
                    .padding()
                    
                    Spacer()
                    
                    //Login Button
                    Button(action: {
                        self.login()
                    }) {
                        Text("Log In")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(buttonGreenColor)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.top, 16)
                            .bold()
                    }
                    
                    Spacer()
                }
                .padding(.top, 350)
                
            }
        }.navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        
        
    }
    
    func login() {
        
                if selectedRole == "Manager" {
                    navigateToManager = true
                } else if selectedRole == "Employee" {
                    navigateToEmployee = true
                }
            }

}

#Preview {
    LoginScreen()
}



extension  View {
    func placeholder<Content: View>(
    when shouldShow: Bool,
    alignment: Alignment = .leading,
    @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment){
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

