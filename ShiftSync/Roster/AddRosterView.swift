import SwiftUI
import FirebaseFirestore

struct AddRosterView: View {
    @ObservedObject var rosterViewModel: RosterViewModel
    @StateObject private var employeeViewModel = EmployeeViewModel() // Using StateObject for ViewModel
    @State private var selectedDate = Date()
    @State private var showingAddShift = false
    @State private var selectedEmployee: EmployeeModel?
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(3600) // 1 hour later
    @State private var workDescription: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        .accentColor(buttonGreenColor)
                        .foregroundColor(appWhiteColor)
                        .colorScheme(.dark)
                    
                    Button("Add Shift") {
                        self.showingAddShift.toggle()
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(buttonGreenColor)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .bold()
                    .sheet(isPresented: $showingAddShift) {
                        NavigationView {
                            VStack {
                                ScrollView {
                                    VStack {
                                        ForEach(employeeViewModel.employees, id: \.id) { employee in
                                            HStack {
                                                Text("\(employee.firstName) \(employee.lastName)")
                                                    .foregroundColor(.black)
                                                    .padding()
                                                Spacer()
                                                if selectedEmployee == employee {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                self.selectedEmployee = employee
                                            }
                                            .background(selectedEmployee == employee ? Color.gray.opacity(0.3) : Color.clear)
                                            .cornerRadius(10)
                                        }
                                    }
    
                                    if selectedEmployee != nil {
                                        Divider()
                                        DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                                            .datePickerStyle(WheelDatePickerStyle())
                                            .padding()
                                        DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                                            .datePickerStyle(WheelDatePickerStyle())
                                            .padding()
                                        TextField("Work Description", text: $workDescription)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .padding()
                                    }
                                    
                                    Spacer()
                                    
                                    Button("Save Shift") {
                                        guard let employee = selectedEmployee else { return }
                                        let newRoster = RosterModel(
                                            employeeID: employee.id ?? "",
                                            employeeName: "\(employee.firstName) \(employee.lastName)",
                                            date: selectedDate,
                                            startTime: startTime,
                                            endTime: endTime,
                                            workDescription: workDescription
                                        )
                                        rosterViewModel.addRoster(newRoster)
                                        self.showingAddShift = false
                                    }
                                    .padding()
                                }
                                .navigationTitle("Select Employee")
                                .toolbar {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button("Cancel") {
                                            self.showingAddShift = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        backButton
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Add Roster")
                            .font(.system(size: 20))
                            .foregroundColor(buttonGreenColor)
                            .bold()
                    }
                }
            }
        }
        .onAppear {
            employeeViewModel.fetchEmployees()
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
}

class RosterViewModel: ObservableObject {
    func addRoster(_ roster: RosterModel) {
        // Add the roster to Firestore
    }
}

struct AddRosterView_Previews: PreviewProvider {
    static var previews: some View {
        AddRosterView(rosterViewModel: RosterViewModel())
    }
}
