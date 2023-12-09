import SwiftUI

struct LoginView: View {
    
    @StateObject private var formViewModel = FormViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("EMAIL"), footer: Text(formViewModel.inlineErrorForEmail).foregroundColor(.red)) {
                        TextField("Email", text: $formViewModel.email)
                            .autocapitalization(.none)
                    }
                    
                    Section(header: Text("PASSWORD"), footer: Text(formViewModel.inlineErrorForPassword).foregroundColor(.red)) {
                        SecureField("Password", text: $formViewModel.password)
                        SecureField("Confirm Password", text: $formViewModel.confirmPassword)
                        
                    }
                }
                Button(action: {}) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 60)
                        .overlay(
                            Text("Login")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        )
                }
                .padding()
                .disabled(!formViewModel.isValid)
            }
            .navigationTitle("Login")
        }
    }
}

#Preview {
    LoginView()
}

