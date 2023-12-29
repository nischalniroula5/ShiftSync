import Foundation
import FirebaseFirestoreSwift

struct EmployeeModel: Identifiable, Codable {
    
    @DocumentID var id: String?
    var firstName: String = ""
    var lastName: String = ""
    var employeeID: String = ""
    var address: String = ""
    var phoneNumber: String = ""
    var emailAddress: String = ""
    var dateOfBirth: Date = Date()
    var role: String = "Employee"
    var imageURL: String? 

    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case employeeID
        case address
        case phoneNumber
        case emailAddress
        case dateOfBirth
        case role
        case imageURL
    }

    var dictionary: [String: Any] {
        return [
            "firstName": firstName,
            "lastName": lastName,
            "employeeID": employeeID,
            "address": address,
            "phoneNumber": phoneNumber,
            "emailAddress": emailAddress,
            "dateOfBirth": dateOfBirth,
            "role": role,
            "imageURL": imageURL ?? ""
        ]
    }
}
