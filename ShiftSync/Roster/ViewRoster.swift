import SwiftUI
import FirebaseFirestore

struct ViewRoster: View {
    @ObservedObject var rosterViewModel: RosterViewModel
    @State private var selectedDate = Date() // State variable to track selected date
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    // DatePicker to select the date
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .onChange(of: selectedDate) { newDate in
                        rosterViewModel.fetchRosters(for: newDate)
                    }
                    .datePickerStyle(DefaultDatePickerStyle())
                    .padding()
                    .accentColor(buttonGreenColor)
                    .foregroundColor(appWhiteColor)
                    .colorScheme(.dark)
                    .background(lightGreenColor)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // List of rostered shifts for the selected date
                    if !rosterViewModel.rostersForSelectedDate.isEmpty {
                        List {
                            ForEach(rosterViewModel.rostersForSelectedDate) { roster in
                                VStack(alignment: .leading) {
                                    Text(roster.employeeName)
                                        .bold()
                                        .foregroundColor(appWhiteColor)
                                    HStack {
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
                        Text("View Roster")
                            .font(.system(size: 20))
                            .foregroundColor(buttonGreenColor)
                            .bold()
                    }
                }
            }
        }
        .onAppear {
            rosterViewModel.fetchRosters(for: selectedDate)
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

struct ViewRoster_Previews: PreviewProvider {
    static var previews: some View {
        ViewRoster(rosterViewModel: RosterViewModel())
    }
}
