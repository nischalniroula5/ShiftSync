//
//  EmployeeViewModel.swift
//  ShiftSync
//
//  Created by Nischal Niroula on 29/12/2023.
//

import Foundation
import FirebaseFirestore

class EmployeesViewModel: ObservableObject {
    @Published var employees: [EmployeeModel] = []
    
    private var db = Firestore.firestore()
    
    init() {
        loadEmployees()
    }
    
    func loadEmployees() {
        db.collection("employees").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.employees = querySnapshot?.documents.compactMap { document -> EmployeeModel? in
                    try? document.data(as: EmployeeModel.self)
                } ?? []
            }
        }
    }
}
