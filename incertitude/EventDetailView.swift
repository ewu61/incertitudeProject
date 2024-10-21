import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct EventDetailView: View {
    let event: Event  // Event passed from MainContentView
    @State private var isRegistered = false  // Track if the user is registered
    @State private var currentUserID = Auth.auth().currentUser?.uid  // Get current user ID
    let db = Firestore.firestore()  // Firestore instance

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(event.name)
                .font(.largeTitle)
                .padding(.top, 20)

            Text("Description: \(event.description)")
                .font(.body)

            Text("Date: \(event.date, style: .date)")
                .font(.body)

            Text("Location: \(event.location)")
                .font(.body)

            Spacer()

            // Register/Unregister button
            Button(action: {
                if isRegistered {
                    unregisterFromEvent()  // If already registered, unregister
                } else {
                    registerForEvent()  // Otherwise, register
                }
            }) {
                Text(isRegistered ? "Unregister" : "Register")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isRegistered ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            checkRegistrationStatus()  // Check if user is already registered when the view appears
        }
        .navigationTitle("Event Details")
    }

    // Check if the user is already registered for the event
    func checkRegistrationStatus() {
        guard let userID = currentUserID else { return }

        let eventRef = db.collection("events").document(event.id)
        eventRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let registeredUsers = data?["registeredUsers"] as? [String] ?? []
                isRegistered = registeredUsers.contains(userID)  // Check if the user is in the array
            } else {
                print("Event does not exist or error fetching event data")
            }
        }
    }

    // Register the user for the event by adding their ID to the registeredUsers array
    func registerForEvent() {
        guard let userID = currentUserID else { return }

        let eventRef = db.collection("events").document(event.id)
        eventRef.updateData([
            "registeredUsers": FieldValue.arrayUnion([userID])  // Add user to registeredUsers array
        ]) { error in
            if let error = error {
                print("Error registering for event: \(error)")
            } else {
                isRegistered = true  // Update local state
                print("Successfully registered for the event!")
            }
        }
    }

    // Unregister the user from the event by removing their ID from the registeredUsers array
    func unregisterFromEvent() {
        guard let userID = currentUserID else { return }

        let eventRef = db.collection("events").document(event.id)
        eventRef.updateData([
            "registeredUsers": FieldValue.arrayRemove([userID])  // Remove user from registeredUsers array
        ]) { error in
            if let error = error {
                print("Error unregistering from event: \(error)")
            } else {
                isRegistered = false  // Update local state
                print("Successfully unregistered from the event!")
            }
        }
    }
}
