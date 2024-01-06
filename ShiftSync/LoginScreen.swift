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
let textFieldColor = Color(red: 58 / 255, green: 84 / 255, blue: 107 / 255) // #3A546B




struct LoginScreen: View {
    
    
    @State private var isAuthenticated = false
    
    @State private var showingPeopleView = false
    
    
    //Variables
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    
    var body: some View {
        NavigationView{
            ZStack{
                backgroundColor
                    .ignoresSafeArea()
                GeometryReader { proxy in
                    VStack {
                        Image("LoginBgBlob")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
                            .edgesIgnoringSafeArea(.all)
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
                }
                .edgesIgnoringSafeArea(.top)

                
                VStack{
                    
                    Image("ShiftSyncLogo")
                        .padding(.top, 5)
                    
                    Spacer()
                    
                    // Email Field
                    VStack {
                        HStack {
                            Image(systemName: "mail.fill")
                                .foregroundColor(.yellow)
                            
                            VStack {
                                TextField("", text: $email)
                                    .keyboardType(.emailAddress)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                                    .foregroundColor(.white)
                                    .bold()
                                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                    .textCase(.lowercase)
                                    .placeholder(when: email.isEmpty){
                                        Text("Email")
                                            .foregroundColor(textFieldColor)
                                            .padding(.leading, 16)
                                    }
                                
                            }
                        }
                        .padding(.top, 260)
                        
                        
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
                                    .placeholder(when: password.isEmpty){
                                        Text("Password")
                                            .foregroundColor(textFieldColor)
                                            .bold()
                                            .padding(.leading, 16)
                                    }
                                
                            } else {
                                SecureField("", text: $password)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                                    .bold()
                                    .foregroundColor(.white)
                                    .placeholder(when: password.isEmpty){
                                        Text("Password")
                                            .foregroundColor(textFieldColor)
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
                    
                    HStack {
                        Spacer()
                        Button (action: {}){
                            Text("Forgot Password?")
                                .foregroundColor(buttonGreenColor)
                                .bold()
                        }
                    }
                    .padding(.horizontal)
                    
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
                    .fullScreenCover(isPresented: $isAuthenticated, onDismiss: {
                                
                            }) {
                                HomePage()
                            }
                    
                    Spacer()
                }
                .padding()
                
            }
        }.navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showAlert) {
                    Alert(title: Text("Login Failed"),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("OK")))
                }
        
        
    }
    
    func login() {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                self.alertMessage = "Invalid Login Credentials. Please check your email and password and try again"
                self.showAlert = true
                
            } else {
                
                print("Login successful")
                self.isAuthenticated = true
            }
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

