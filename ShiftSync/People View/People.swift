import SwiftUI

struct People: View {
    
    @State private var showingViewEmployeeView = false
    @State private var showingAddEmployeeView = false
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
                            showingViewEmployeeView = true
                                        }) {
                                            HStack {
                                                Text("View Employee")
                                                    .foregroundColor(.white)
                                                    .bold()
                                                Spacer()
                                                Image(systemName: "person.2.fill")
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
                                        .fullScreenCover(isPresented: $showingViewEmployeeView) {
                                            ViewEmployee()
                                        }
                    
                    Button(action: {
                            showingAddEmployeeView = true
                                        }) {
                                            HStack {
                                                Text("Add Employee")
                                                    .foregroundColor(.white)
                                                    .bold()
                                                Spacer()
                                                Image(systemName: "person.fill.badge.plus")
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
                                        .fullScreenCover(isPresented: $showingAddEmployeeView) {
                                            AddEmployee()
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
                                    Text("People")
                                        .font(.system(size: 20))
                                        .foregroundColor(buttonGreenColor)
                                        .bold()
                                }
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        //.navigationBarBackButtonHidden(true)
                        //.navigationBarHidden(true)
        }
    }
}

struct People_Previews: PreviewProvider {
    static var previews: some View {
        People()
    }
}


/*
 HStack {
     Text("Add Employee")
         .foregroundColor(.white)
         .bold()
     Spacer()
     Image(systemName: "person.fill.badge.plus")
         .font(.title)
         .foregroundColor(appWhiteColor)
     
 }
 .padding()
 .background(lightGreenColor)
 .cornerRadius(10)
 .padding(.horizontal)
 */
