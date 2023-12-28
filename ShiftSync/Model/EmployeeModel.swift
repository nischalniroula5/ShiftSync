//
//  EmployeeModel.swift
//  ShiftSync
//
//  Created by Nischal Niroula on 28/12/2023.
//

import Foundation
import SwiftUI


struct EmployeeModel: Identifiable {
    var id = UUID()
    var firstName: String = ""
    var lastName: String = ""
    var employeeID: String = ""
    var address: String = ""
    var phoneNumber: String = ""
    var emailAddress: String = ""
    var dateOfBirth: Date = Date()
    var role: String = "Employee"
}
