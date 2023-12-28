//
//  AddEmployee.swift
//  ShiftSync
//
//  Created by Nischal Niroula on 28/12/2023.
//

import SwiftUI

struct AddEmployee: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var employee = EmployeeModel()
    
    @State private var selectedRole = "Manager"
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    employeeForm
                    addEmployeeButton
                    Spacer()
                }
                .padding(.top, 10)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
                ToolbarItem(placement: .principal) {
                    Text("Add Employee")
                        .font(.system(size: 20))
                        .foregroundColor(buttonGreenColor)
                        .bold()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var employeeForm: some View {
        Form {
            Section(header: CustomSectionHeader(text: "Personal Information")) {
                TextField("", text: $employee.employeeID)
                    .keyboardType(.numberPad)
                    .foregroundColor(appWhiteColor)
                    .bold()
                    .placeholder(when: employee.employeeID.isEmpty){
                        Text("Employee ID")
                            .foregroundColor(textFieldColor)
                    }
                
                TextField("", text: $employee.firstName)
                    .keyboardType(.namePhonePad)
                    .foregroundColor(appWhiteColor)
                    .bold()
                    .placeholder(when: employee.firstName.isEmpty){
                        Text("First Name")
                            .foregroundColor(textFieldColor)
                    }
                TextField("", text: $employee.lastName)
                    .keyboardType(.namePhonePad)
                    .foregroundColor(appWhiteColor)
                    .bold()
                    .placeholder(when: employee.lastName.isEmpty){
                        Text("Last Name")
                            .foregroundColor(textFieldColor)
                    }
                
                TextField("", text: $employee.address)
                    .keyboardType(.emailAddress)
                    .foregroundColor(appWhiteColor)
                    .bold()
                    .placeholder(when: employee.address.isEmpty){
                        Text("Address")
                            .foregroundColor(textFieldColor)
                    }
                
                
                DatePicker(
                    "Select Date of Birth",
                    selection: $employee.dateOfBirth,
                    displayedComponents: .date
                )
                .datePickerStyle(DefaultDatePickerStyle()) // Use the default style
                .foregroundColor(textFieldColor)
                .padding(.bottom, 5)
                .accentColor(buttonGreenColor)
            }
            .sectionStyle()
            
            Section(header: CustomSectionHeader(text: "Contact Information")) {
                TextField("", text: $employee.phoneNumber)
                    .keyboardType(.phonePad)
                    .foregroundColor(appWhiteColor)
                    .bold()
                    .placeholder(when: employee.phoneNumber.isEmpty){
                        Text("Phone Number")
                            .foregroundColor(textFieldColor)
                    }
                
                TextField("", text: $employee.emailAddress)
                    .keyboardType(.emailAddress)
                    .foregroundColor(appWhiteColor)
                    .bold()
                    .placeholder(when: employee.emailAddress.isEmpty){
                        Text("Email Address")
                            .foregroundColor(textFieldColor)
                    }
            }
            .sectionStyle()
            
            Section(header: CustomSectionHeader(text: "Picture")) {
                Button("Select Image") {
                    // Implement image selection action
                }
            }
            .sectionStyle()
            
            Picker("Select Role", selection: $selectedRole) {
                                    Text("Manager").tag("Manager")
                                    Text("Employee").tag("Employee")
                                }
            .pickerStyle(.menu)
                                .padding()
        }
        .scrollContentBackground(.hidden)
    }
    
    var addEmployeeButton: some View {
        Button("Add Employee") {
            // Add Employee Function
        }
        .buttonStyle()
    }
    
    var backButton: some View {
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
}

// Define extensions for reusable styles
extension View {
    func textFieldStyle() -> some View {
        self
            .foregroundColor(appWhiteColor)
            .bold()
    }
    
    func sectionStyle() -> some View {
        self
            .foregroundColor(appWhiteColor)
            .listRowBackground(lightGreenColor)
    }
    
    func buttonStyle() -> some View {
        self
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(buttonGreenColor)
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top, 16)
            .bold()
    }
}

struct CustomSectionHeader: View {
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(appWhiteColor) // Use your predefined color
            .padding(.vertical, 10)
            .bold()
            .listRowInsets(EdgeInsets())
    }
}
struct AddEmployee_Previews: PreviewProvider {
    static var previews: some View {
        AddEmployee()
    }
}
