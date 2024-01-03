//
//  AddEmployee.swift
//  ShiftSync
//
//  Created by Nischal Niroula on 28/12/2023.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import PhotosUI
import FirebaseStorage

struct AddEmployee: View {
    @State private var isDataSaved = false
    
    // State for alerts and navigation
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImageData: Data?
    @Environment(\.presentationMode) var presentationMode
    @State private var employee = EmployeeModel()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Choose Role:")
                            .foregroundColor(appWhiteColor)
                            .bold()
                        Spacer()
                        Picker("", selection: $employee.role) {
                            Text("Manager").tag("Manager")
                            Text("Employee").tag("Employee")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(appWhiteColor)
                        .bold()
                    }
                    .padding()
                    .background(lightGreenColor)
                    .cornerRadius(10)
                    .padding(.horizontal)
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    var employeeForm: some View {
        Form {
            Section(header: CustomSectionHeader(text: "Personal Information")) {
                TextField("", text: $employee.employeeID)
                    .keyboardType(.numberPad)
                    .foregroundColor(appWhiteColor)
                    .bold()
                    .disableAutocorrection(true)
                    .placeholder(when: employee.employeeID.isEmpty){
                        Text("Employee ID")
                            .foregroundColor(textFieldColor)
                    }
                
                TextField("", text: $employee.firstName)
                    .keyboardType(.namePhonePad)
                    .foregroundColor(appWhiteColor)
                    .bold()
                    .disableAutocorrection(true)
                    //.autocapitalization(.words)
                    .textInputAutocapitalization(.words)
                    .placeholder(when: employee.firstName.isEmpty){
                        Text("First Name")
                            .foregroundColor(textFieldColor)
                    }
                TextField("", text: $employee.lastName)
                    .keyboardType(.namePhonePad)
                    .foregroundColor(appWhiteColor)
                    .bold()
                    .disableAutocorrection(true)
                    //.autocapitalization(.words)
                    .textInputAutocapitalization(.words)
                    .placeholder(when: employee.lastName.isEmpty){
                        Text("Last Name")
                            .foregroundColor(textFieldColor)
                    }
                
                TextField("", text: $employee.address)
                    .keyboardType(.emailAddress)
                    .foregroundColor(appWhiteColor)
                    .bold()
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.words)
                    .placeholder(when: employee.address.isEmpty){
                        Text("Address")
                            .foregroundColor(textFieldColor)
                    }
                
                
                DatePicker(
                    "Select Date of Birth",
                    selection: $employee.dateOfBirth,
                    displayedComponents: .date
                )
                .datePickerStyle(DefaultDatePickerStyle())
                .foregroundColor(appWhiteColor)
                .padding(.bottom, 5)
                .accentColor(buttonGreenColor)
            }
            .sectionStyle()
            
            Section(header: CustomSectionHeader(text: "Contact Information")) {
                TextField("", text: $employee.phoneNumber)
                    .keyboardType(.phonePad)
                    .foregroundColor(appWhiteColor)
                    .bold()
                    .disableAutocorrection(true)
                    .placeholder(when: employee.phoneNumber.isEmpty){
                        Text("Phone Number")
                            .foregroundColor(textFieldColor)
                    }
                
                TextField("", text: $employee.emailAddress)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .foregroundColor(appWhiteColor)
                    .bold()
                    .placeholder(when: employee.emailAddress.isEmpty){
                        Text("Email Address")
                            .foregroundColor(textFieldColor)
                    }
            }
            .sectionStyle()
            
            Section(header: CustomSectionHeader(text: "Picture")) {
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: 1,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Text("Select a photo")
                }
                .onChange(of: selectedItems) { newItems in
                    // Handle the new selection
                    if let firstItem = newItems.first {
                        Task {
                            // Retrieve the selected item's data
                            if let data = try? await firstItem.loadTransferable(type: Data.self) {
                                selectedImageData = data
                            }
                        }
                    }
                }
                
                // Display the selected image if available
                if let selectedImageData = selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
            }
            .sectionStyle()
            
        }
        .scrollContentBackground(.hidden)
        
        
    }
    
    var addEmployeeButton: some View {
        Button("Add Employee") {
            saveEmployeeToFirestore(employee)
        }
        .buttonStyle()
        .fullScreenCover(isPresented: $isDataSaved) {
            HomePage()
        }
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
    
    func saveEmployeeToFirestore(_ employee: EmployeeModel) {
        // First, check if there is an image to upload
        if let imageData = selectedImageData {
            // Upload image to Firebase Storage
            let storageRef = Storage.storage().reference().child("employee_images/\(UUID().uuidString).jpg")
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                guard error == nil else {
                    // Handle error in image upload
                    alertTitle = "Error"
                    alertMessage = "Failed to upload image: \(error!.localizedDescription)"
                    showAlert = true
                    return
                }
                
                // Get download URL
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Handle error in getting download URL
                        alertTitle = "Error"
                        alertMessage = "Failed to get image URL: \(error!.localizedDescription)"
                        showAlert = true
                        return
                    }
                    
                    // Update employee model with image URL
                    var updatedEmployee = employee
                    updatedEmployee.imageURL = downloadURL.absoluteString
                    
                    // Save employee data to Firestore
                    saveEmployeeDataToFirestore(updatedEmployee)
                }
            }
        } else {
            // If there is no image, save employee data directly
            saveEmployeeDataToFirestore(employee)
        }
    }
    
    func saveEmployeeDataToFirestore(_ employee: EmployeeModel) {
        let db = Firestore.firestore()
        do {
            let _ = try db.collection("employees").addDocument(from: employee) { error in
                if let error = error {
                    self.alertTitle = "Error"
                    self.alertMessage = "Something went wrong: \(error.localizedDescription)"
                    self.showAlert = true
                } else {
                    self.alertTitle = "Success"
                    self.alertMessage = "Employee Added"
                    self.showAlert = true

                    // Delay the dismissal of the alert and then navigate to HomePage
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.showAlert = false // Dismiss the alert
                        self.isDataSaved = true // Trigger navigation to HomePage
                    }
                }
            }
        } catch let error {
            self.alertTitle = "Error"
            self.alertMessage = "Something went wrong: \(error.localizedDescription)"
            self.showAlert = true
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
