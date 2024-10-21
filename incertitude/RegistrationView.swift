import SwiftUI
import FirebaseAuth

struct RegistrationView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var registrationMessage: String = ""

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                registerUser()
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            if !registrationMessage.isEmpty {
                Text(registrationMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .navigationTitle("Create Account")  // Title for the sign-up screen
        .navigationBarBackButtonHidden(false)  // Ensures the back button is shown
    }

    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                registrationMessage = "Error: \(error.localizedDescription)"
            } else {
                registrationMessage = "Account created successfully!"
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
