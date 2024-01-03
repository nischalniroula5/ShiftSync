//
//  AddRoster.swift
//  ShiftSync
//
//  Created by Nischal Niroula on 30/12/2023.
//

import SwiftUI
import FirebaseFirestore

struct AddRoster: View {
    @State private var selectedDate: Date = Date()
    @State private var showingRosterDetails = false
    @State private var selectedEmployee: EmployeeModel?
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var workDescription: String = ""
    
    // Replace this with your actual view model that fetches employees
    //@StateObject private var employeeViewModel = EmployeeModel()
    
    var body: some View {
        NavigationView {
            VStack {
                CalendarView(selectedDate: $selectedDate)
                    .onChange(of: selectedDate) { _ in
                        showingRosterDetails = true
                    }
                
                if showingRosterDetails {
                    rosterDetailView
                }
            }
            .navigationTitle("Add Roster")
        }
        .onAppear {
            employeeViewModel.fetchEmployees()
        }
    }
    
    var rosterDetailView: some View {
        VStack {
            Text("Roster Details for \(selectedDate, formatter: dateFormatter)")
            Divider()
            
            Picker("Select Employee", selection: $selectedEmployee) {
                ForEach(employeeViewModel.employees, id: \.id) { employee in
                    Text(employee.firstName + " " + employee.lastName).tag(employee as EmployeeModel?)
                }
            }
            
            DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
            DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
            
            TextField("Work Description", text: $workDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Add Roster") {
                // Implement the logic to add roster details
            }
            .buttonStyle(FilledRoundedButtonStyle())
        }
        .padding()
    }
    
    // Custom date formatter
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

// Define your CalendarView and FilledRoundedButtonStyle
// ...

// EmployeeViewModel to fetch employees
class EmployeeViewModel: ObservableObject {
    @Published var employees: [EmployeeModel] = []
    // ... Fetch employees from Firestore ...
}


#Preview {
    AddRoster()
}
