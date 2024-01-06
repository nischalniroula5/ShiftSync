import SwiftUI
import FirebaseFirestore

struct AddRosterView: View {
    @ObservedObject var rosterViewModel: RosterViewModel
    @StateObject private var employeeViewModel = EmployeeViewModel()
    @State private var selectedDate = Date()
    @State private var showingAddShift = false
    @State private var selectedEmployeeIndex = 0
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(3600)
    @State private var workDescription: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                
                backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .onChange(of: selectedDate, perform: { newDate in
                            rosterViewModel.rostersForSelectedDate = []
                            rosterViewModel.fetchRosters(for: newDate)
                        })
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .accentColor(buttonGreenColor)
                        .foregroundColor(appWhiteColor)
                        .colorScheme(.dark)
                    Button("Add Shift") {
                        self.showingAddShift.toggle()
                        employeeViewModel.fetchEmployees()
                        showingAddShift = true
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
                        addShiftSheet
                    }
                    
                    if !rosterViewModel.rostersForSelectedDate.isEmpty {
                        List {
                            ForEach(rosterViewModel.rostersForSelectedDate) { roster in
                                VStack(alignment: .leading) {
                                    Text(roster.employeeName)
                                        .bold()
                                        .foregroundColor(appWhiteColor)
                                    HStack{
                                        Text("Start: \(roster.startTime.formatted(.dateTime.hour().minute()))")
                                            .foregroundColor(appWhiteColor)
                                        Spacer()
                                        Text("End: \(roster.endTime.formatted(.dateTime.hour().minute()))")
                                            .foregroundColor(appWhiteColor)
                                    }
                                    
                                    
                                }
                                .listRowBackground(lightGreenColor)
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .background(backgroundColor)
                        
                    } else {
                        Text("No shifts scheduled for this date")
                            .padding()
                            .foregroundColor(appWhiteColor)
                            .bold()
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
        .onDisappear {
            rosterViewModel.detachListener()
        }
        .onAppear {
            employeeViewModel.fetchEmployees()
            rosterViewModel.fetchRosters(for: selectedDate)
        }
        .alert(isPresented: $rosterViewModel.showAlert) {
            Alert(title: Text(rosterViewModel.alertTitle), message: Text(rosterViewModel.alertMessage), dismissButton: .default(Text("OK")))
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
    
    func rosterEntryView(_ roster: RosterModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(roster.employeeName)
                .font(.headline)
            Text("Start Time: \(roster.startTime.formatted())")
            Text("End Time: \(roster.endTime.formatted())")
            Text("Work Description: \(roster.workDescription)")
            Divider()
        }
        .padding()
        .background(lightGreenColor)
        .cornerRadius(10)
    }
    
    var addShiftSheet: some View {
        NavigationView {
            ZStack {
                backgroundColor
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Text("Choose Employee:")
                            .foregroundColor(appWhiteColor)
                            .bold()
                        Spacer()
                        Picker("Select Employee", selection: $selectedEmployeeIndex) {
                            ForEach(0..<employeeViewModel.employees.count, id: \.self) { index in
                                Text(employeeViewModel.employees[index].fullName).tag(index)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(appWhiteColor)
                        .bold()
                    }
                    .padding()
                    .background(lightGreenColor)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    Form {
                        Section(header: CustomSectionHeader(text: "Timing")) {
                            DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .foregroundColor(appWhiteColor)
                                .accentColor(buttonGreenColor)
                                .colorScheme(.dark)
                                .bold()
                            
                            DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .foregroundColor(appWhiteColor)
                                .accentColor(buttonGreenColor)
                                .colorScheme(.dark)
                                .bold()
                                
                            TextField("", text: $workDescription)
                                .keyboardType(.emailAddress)
                                .disableAutocorrection(true)
                                .foregroundColor(appWhiteColor)
                                .bold()
                                .placeholder(when: workDescription.isEmpty){
                                    Text("Work Description")
                                        .foregroundColor(textFieldColor)
                                }
                        }
                        .foregroundColor(appWhiteColor)
                        .listRowBackground(lightGreenColor)
                    }
                    .scrollContentBackground(.hidden)
                    .scrollDisabled(true)
                    
                    Spacer()
                    
                    Button("Save Shift") {
                        let selectedEmployee = employeeViewModel.employees[selectedEmployeeIndex]
                        
                        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
                        
                        let startTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: startTime)
                        let endTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: endTime)
                        
                        dateComponents.hour = startTimeComponents.hour
                        dateComponents.minute = startTimeComponents.minute
                        let combinedStartTime = Calendar.current.date(from: dateComponents)!
                        
                        dateComponents.hour = endTimeComponents.hour
                        dateComponents.minute = endTimeComponents.minute
                        let combinedEndTime = Calendar.current.date(from: dateComponents)!
                        
                        let newRoster = RosterModel(
                            employeeID: selectedEmployee.id ?? "",
                            employeeName: selectedEmployee.fullName,
                            date: selectedDate,
                            startTime: combinedStartTime,
                            endTime: combinedEndTime,
                            workDescription: workDescription
                        )
                        rosterViewModel.addRoster(newRoster)
                        self.showingAddShift = false
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(buttonGreenColor)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.vertical)
                    .bold()
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            self.showingAddShift = false
                        }
                        .foregroundColor(buttonGreenColor)
                    }
                }
            }
        }
    }
}

// Assuming EmployeeModel has a computed property for full name
extension EmployeeModel {
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

extension Calendar {
    func combine(date: Date, time: Date) -> Date {
        let dateComponents = self.dateComponents([.year, .month, .day], from: date)
        let timeComponents = self.dateComponents([.hour, .minute, .second], from: time)
        
        return self.date(from: DateComponents(
            year: dateComponents.year,
            month: dateComponents.month,
            day: dateComponents.day,
            hour: timeComponents.hour,
            minute: timeComponents.minute,
            second: timeComponents.second
        ))!
    }
}



class RosterViewModel: ObservableObject {
    @Published var rostersForSelectedDate: [RosterModel] = []
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    private let db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    func addRoster(_ roster: RosterModel) {
        do {
            let _ = try db.collection("roster").addDocument(from: roster) { error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.alertTitle = "Error"
                        self.alertMessage = "Something went wrong: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.alertTitle = "Success"
                        self.alertMessage = "Shift Added Successfully"
                        self.showAlert = true
                    }
                }
            }
        } catch let error {
            DispatchQueue.main.async {
                self.alertTitle = "Error"
                self.alertMessage = "Something went wrong: \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
    
    func fetchRosters(for date: Date) {
        // Detach any existing listener before attaching a new one
        listenerRegistration?.remove()
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        listenerRegistration = db.collection("roster")
            .whereField("date", isGreaterThanOrEqualTo: startOfDay)
            .whereField("date", isLessThan: endOfDay)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let strongSelf = self else { return }
                
                if let error = error {
                    DispatchQueue.main.async {
                        strongSelf.alertTitle = "Error"
                        strongSelf.alertMessage = "Error getting documents: \(error.localizedDescription)"
                        strongSelf.showAlert = true
                    }
                } else {
                    DispatchQueue.main.async {
                        strongSelf.rostersForSelectedDate = querySnapshot?.documents.compactMap { document in
                            try? document.data(as: RosterModel.self)
                        } ?? []
                    }
                }
            }
    }
    
    func detachListener() {
        listenerRegistration?.remove()
    }
}


struct AddRosterView_Previews: PreviewProvider {
    static var previews: some View {
        AddRosterView(rosterViewModel: RosterViewModel())
    }
}
