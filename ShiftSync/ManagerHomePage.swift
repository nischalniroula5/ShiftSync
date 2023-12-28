import SwiftUI

struct ManagerHomePage: View {
    
    @State private var currentTime = Date()
    @State private var showingPeopleView = false
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short // for hour and minute; e.g., '9:41 AM'
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy" // e.g., '25 December 2023'
        return formatter
    }()
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect() // Update every minute

    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()

                VStack(spacing: 5) {
                    // Time and Date
                    Text(timeFormatter.string(from: currentTime))
                        .font(.custom("Poppins-Black", size: 48))
                        .foregroundColor(appWhiteColor)
                    
                    Text(dateFormatter.string(from: currentTime))
                        .font(.custom("Poppins-Medium", size: 16))
                        .foregroundColor(appWhiteColor)
                        .padding(.bottom, 20)
                    
                    Rectangle()
                        .fill(buttonGreenColor)
                        .frame(height: 2)
                    
                    Spacer()
                    
                    // Menu Grids
                    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
                                   
                    LazyVGrid(columns: gridItems, spacing: 20) {
                        Button(action: {
                                                showingPeopleView = true
                                            }) {
                                                GridMenuButton(title: "People", systemImageName: "person.2.fill")
                                            }
                                            .fullScreenCover(isPresented: $showingPeopleView) {
                                                People()
                                            }
                        
                        GridMenuButton(title: "Roster", systemImageName: "suitcase.fill")
                        GridMenuButton(title: "Tasks", systemImageName: "list.bullet.rectangle.portrait.fill")
                    }
                    .padding(.bottom, 100)
                }
                .onReceive(timer) { input in
                    currentTime = input
                }
                .padding()
            }
            .navigationBarItems(
                leading: Image(systemName: "bell.fill")
                    .foregroundColor(buttonGreenColor)
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            
        }
    }
}

struct GridMenuButton: View {
    var title: String
    var systemImageName: String
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                VStack {
                    Text(title)
                        .foregroundColor(appWhiteColor)
                        .font(.custom("Poppins", size: 20))
                        .bold()
                        .padding([.top, .leading])
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: systemImageName)
                            .font(.largeTitle)
                            .foregroundColor(appWhiteColor)
                            .padding([.bottom, .trailing])
                    }
                }
            }
        }
        .frame(width: 155, height: 155)
        .background(lightGreenColor)
        .cornerRadius(16)
        .shadow(color: .black, radius: 2, x: 0, y: 4)
    }
}

struct ManagerHomePage_Previews: PreviewProvider {
    static var previews: some View {
        ManagerHomePage()
    }
}
