import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MainContentView: View {
    @State private var events: [Event] = []  // List to store events
    @Binding var isUserLoggedIn: Bool  // Binding to manage login state (accept as argument)

    let db = Firestore.firestore()  // Firestore instance

    var body: some View {
        NavigationStack {
            List(events) { event in
                // Each event is clickable and navigates to EventDetailView
                NavigationLink(destination: EventDetailView(event: event)) {
                    VStack(alignment: .leading) {
                        Text(event.name).font(.headline)
                        Text(event.description).font(.subheadline)
                        Text(event.date, style: .date).font(.footnote).foregroundColor(.gray)
                        Text(event.location).font(.footnote).foregroundColor(.blue)
                    }
                }
            }
            .onAppear {
                fetchEvents()  // Fetch events when the view appears
            }
            .navigationTitle("Events")
            .navigationBarItems(trailing: Button(action: {
                logoutUser()  // Call the logout function
            }) {
                Text("Logout")
                    .foregroundColor(.red)
            })
        }
    }

    // Function to fetch events from Firestore
    func fetchEvents() {
        db.collection("events").order(by: "date", descending: false).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching events: \(error)")
            } else {
                self.events = snapshot?.documents.compactMap { document -> Event? in
                    let data = document.data()
                    guard let name = data["name"] as? String,
                          let description = data["description"] as? String,
                          let timestamp = data["date"] as? Timestamp,
                          let location = data["location"] as? String else {
                        return nil
                    }
                    return Event(id: document.documentID, name: name, description: description, date: timestamp.dateValue(), location: location)
                } ?? []
            }
        }
    }

    // Function to log out the user
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            isUserLoggedIn = false  // Reset login state
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}

// Event Model
struct Event: Identifiable {
    var id: String
    var name: String
    var description: String
    var date: Date
    var location: String
}

