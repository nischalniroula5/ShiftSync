import SwiftUI

struct AddRosterView: View {
    @State private var selectedEmployee = ""
    @State private var selectedDate = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var daysOfWeek = [false, false, false, false, false, false, false] // Represents Sun through Sat
    let employees: [String] = ["John Doe", "Jane Smith", "Emily Johnson"] // Example employee names

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Employee")) {
                    Picker("Select Employee", selection: $selectedEmployee) {
                        ForEach(employees, id: \.self) { employee in
                            Text(employee).tag(employee)
                        }
                    }
                }
                
                Section(header: Text("Date")) {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                }
                
                Section(header: Text("Time")) {
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Days")) {
                    Toggle("Sunday", isOn: $daysOfWeek[0])
                    Toggle("Monday", isOn: $daysOfWeek[1])
                    Toggle("Tuesday", isOn: $daysOfWeek[2])
                    Toggle("Wednesday", isOn: $daysOfWeek[3])
                    Toggle("Thursday", isOn: $daysOfWeek[4])
                    Toggle("Friday", isOn: $daysOfWeek[5])
                    Toggle("Saturday", isOn: $daysOfWeek[6])
                }
                
                Button("Save Roster") {
                    // Validation and save action goes here
                }
            }
            .navigationBarTitle("Add Roster", displayMode: .inline)
        }
    }
}

struct AddRosterView_Previews: PreviewProvider {
    static var previews: some View {
        AddRosterView()
    }
}
