import SwiftUI
import Firebase
import FirebaseStorage
import PhotosUI

struct EditEmployeeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var employee: EmployeeModel
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var selectedImageData: Data?
    @State private var selectedImageItem: PhotosPickerItem?
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    Form {
                        Section(header: CustomSectionHeader(text: "Personal Information")) {
                            TextField("Employee ID", text: $employee.employeeID)
                            TextField("First Name", text: $employee.firstName)
                            TextField("Last Name", text: $employee.lastName)
                            TextField("Address", text: $employee.address)
                            DatePicker("Date of Birth", selection: $employee.dateOfBirth, displayedComponents: .date)
                        }
                        
                        Section(header: CustomSectionHeader(text: "Contact Information")) {
                            TextField("Phone Number", text: $employee.phoneNumber)
                            TextField("Email Address", text: $employee.emailAddress)
                        }
                        
                        Section(header: CustomSectionHeader(text: "Picture")) {
                            if let selectedImageData = selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                            } else if let imageURL = employee.imageURL, let url = URL(string: imageURL) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image.resizable().scaledToFit()
                                    case .failure:
                                        Image(systemName: "person.crop.circle.badge.xmark").resizable().scaledToFit()
                                    case .empty:
                                        ProgressView()
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                            PhotosPicker(
                                selection: $selectedImageItem,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                Text("Select a new photo")
                            }
                        }
                    }
                    
                    Button("Update Employee") {
                        updateEmployeeDataToFirestore()
                    }
                    .buttonStyle()
                    
                    Button("Delete Employee") {
                        deleteEmployeeFromFirestore()
                    }
                    .buttonStyle()
                }
            }
            .navigationTitle("Edit Employee")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    updateEmployeeDataToFirestore()
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func updateEmployeeDataToFirestore() {
        // Your code to update the employee in Firestore
        // Including uploading the image if selectedImageData is not nil
    }
    
    func deleteEmployeeFromFirestore() {
        // Your code to delete the employee from Firestore
    }
}

struct EditEmployeeView_Previews: PreviewProvider {
    static var previews: some View {
        EditEmployeeView(employee: EmployeeModel())
    }
}
