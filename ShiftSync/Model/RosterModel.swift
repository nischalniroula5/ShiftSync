import Foundation
import FirebaseFirestoreSwift

struct RosterModel: Identifiable, Codable {
    @DocumentID var id: String? // Firestore document ID
    var employeeID: String // ID of the employee assigned to the shift
    var employeeName: String // Name of the employee assigned to the shift
    var date: Date // The date of the shift
    var startTime: Date // The start time of the shift
    var endTime: Date // The end time of the shift
    var workDescription: String // Description of the work or shift notes

    // Use CodingKeys to map the model properties to Firestore fields if needed
    enum CodingKeys: String, CodingKey {
        case id
        case employeeID
        case employeeName
        case date
        case startTime
        case endTime
        case workDescription
    }

    // Dictionary representation for Firestore
    var dictionary: [String: Any] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return [
            "employeeID": employeeID,
            "employeeName": employeeName,
            "date": formatter.string(from: date),
            "startTime": formatter.string(from: startTime),
            "endTime": formatter.string(from: endTime),
            "workDescription": workDescription
        ]
    }

    // Initializer that can be used to create a new instance
    init(employeeID: String, employeeName: String, date: Date, startTime: Date, endTime: Date, workDescription: String) {
        self.employeeID = employeeID
        self.employeeName = employeeName
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.workDescription = workDescription
    }
}
