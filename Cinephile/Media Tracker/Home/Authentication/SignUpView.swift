import SwiftUI
import Networking
import Models
import SafariServices
import AuthenticationServices
import AppAccount

struct SignUpView: View {
    
    @StateObject private var formViewModel = FormViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("USERNAME")) {
                        TextField("Username", text: $formViewModel.username)
                            .autocapitalization(.none)
                    }
                    
                    Section(header: Text("EMAIL"), footer: Text(formViewModel.inlineErrorForEmail).foregroundColor(.red)) {
                        TextField("Email", text: $formViewModel.email)
                            .autocapitalization(.none)
                    }
                    
                    Section(header: Text("PASSWORD"), footer: Text(formViewModel.inlineErrorForPassword).foregroundColor(.red)) {
                        SecureField("Password", text: $formViewModel.password)
                        SecureField("Confirm Password", text: $formViewModel.confirmPassword)
                        
                    }
                }
                Button(action: {
                    let model = SignUpModel(username: formViewModel.username, email: formViewModel.email, password: formViewModel.password)
                    SignUpViewModel.shared.signUp(user: model) { result in
                        print(result)
                    }
                }) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 60)
                        .overlay(
                            Text("Sing Up")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        )
                }
                .padding()
                .disabled(!formViewModel.isValid)
            }
            .navigationTitle("Sing Up")
        }
    }
}

#Preview {
    SignUpView()
}
