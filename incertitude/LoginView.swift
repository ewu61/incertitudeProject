import FirebaseAuth
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginMessage: String = ""

    // Binding to track if the user is logged in
    @Binding var isUserLoggedIn: Bool

    var body: some View {
        NavigationStack {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .padding(.vertical)
                // email field
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                        .padding()
                    TextField("Please enter email", text: $email)
                        .keyboardType(.namePhonePad)
                }
                .overlay(RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal)
                .foregroundColor(.gray)
                // password field
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                        .padding()
                    SecureField("Please enter password", text: $password)
                        .keyboardType(.namePhonePad)
                }
                .overlay(RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal)
                .foregroundColor(.gray)

                // login button
                Button(action: {
                    loginUser()
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(35)
                }
                .padding()

                if !loginMessage.isEmpty {
                    Text(loginMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                NavigationLink(destination: RegistrationView()) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                }
                .padding()
            }
            .padding()
            .navigationTitle("Login Page") // page title
        }
    }

    func loginUser() {
        // Invoke the firebase login method
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                loginMessage = "Error: \(error.localizedDescription)"
            } else {
                loginMessage = "Logged in successfully!"
                // Switch to main content after successful login
                DispatchQueue.main.async {
                    isUserLoggedIn = true // Update the binding to log the user in
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isUserLoggedIn: .constant(false))
    }
}
