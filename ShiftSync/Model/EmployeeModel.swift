//
//  EmployeeModel.swift
//  ShiftSync
//
//  Created by Nischal Niroula on 28/12/2023.
//

import Foundation
import FirebaseFirestoreSwift


struct EmployeeModel: Identifiable, Codable {
    
    @DocumentID var id : String?
    var firstName: String = ""
    var lastName: String = ""
    var employeeID: String = ""
    var address: String = ""
    var phoneNumber: String = ""
    var emailAddress: String = ""
    var dateOfBirth: Date = Date()
    var role: String = "Employee"
    
    var dictionary: [String: Any] {
        return ["firstName": firstName, "lastName": lastName, "employeeID": employeeID, "address": address, "phoneNumber": phoneNumber, "emailAddress": emailAddress, "dateOfBirth": dateOfBirth, "role": role]
    }
}
