//
//  ViewEmployee.swift
//  ShiftSync
//
//  Created by Nischal Niroula on 28/12/2023.
//
import SwiftUI
import FirebaseFirestore

class EmployeeViewModel: ObservableObject {
    @Published var employees: [EmployeeModel] = []
    
    private var db = Firestore.firestore()
    
    func fetchEmployees() {
        db.collection("employees").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.employees = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: EmployeeModel.self)
            }
        }
    }
}


struct ViewEmployee: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = EmployeeViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    SearchBar(text: $searchText)
                    List(viewModel.employees
                        .filter({ searchText.isEmpty ? true : $0.firstName.contains(searchText) || $0.lastName.contains(searchText) })
                        .sorted(by: { $0.firstName < $1.firstName })) { employee in
                            HStack {
                                // AsyncImage to load and display the image from a URL
                                if let imageURL = employee.imageURL, let url = URL(string: imageURL) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 25, height: 25)
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                } else {
                                    // Placeholder image if imageURL is not valid
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .foregroundColor(appWhiteColor)
                                        .frame(width: 25, height: 25)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(employee.firstName + " " + employee.lastName).bold().foregroundColor(appWhiteColor)
                                    Text(employee.emailAddress).foregroundColor(textFieldColor).font(.system(size:14))
                                    
                                }
                                .padding(.leading, 10)
                            }
                            .listRowBackground(lightGreenColor)
                            
                            
                            
                        }
                        .scrollContentBackground(.hidden)
                        .background(backgroundColor)
                    
                }
                .onAppear {
                    viewModel.fetchEmployees()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
                ToolbarItem(placement: .principal) {
                    Text("View Employee")
                        .font(.system(size: 20))
                        .foregroundColor(buttonGreenColor)
                        .bold()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        }
        .foregroundColor(buttonGreenColor)
    }
}

// SearchBar component
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(lightGreenColor)
                .cornerRadius(8)
                .foregroundColor(appWhiteColor)
                .bold()
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.yellow)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                            .bold()
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.yellow)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
        }
        .padding(.top, 10)
    }
}



#Preview {
    ViewEmployee()
}
