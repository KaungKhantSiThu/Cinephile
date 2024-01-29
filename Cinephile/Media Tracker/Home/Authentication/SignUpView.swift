import SwiftUI

struct SignUpView: View {
    
    @StateObject private var formViewModel = FormViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.purple
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                
                VStack {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    TextField("Username", text: $formViewModel.username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(0))
                        .autocapitalization(.none)
                    
                    VStack {
                        TextField("Email", text: $formViewModel.email)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(0))
                            .autocapitalization(.none)
                        
                        Text(formViewModel.inlineErrorForEmail).foregroundColor(.red)
                    }
                    
                    VStack {
                        SecureField("Password", text: $formViewModel.password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(0))
                            .autocapitalization(.none)
                        
                        SecureField("Confirm Password", text: $formViewModel.confirmPassword)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(0))
                            .autocapitalization(.none)
                        
                        Text(formViewModel.inlineErrorForPassword).foregroundColor(.red)
                    }
//                        Section(header: Text("EMAIL"), footer: Text(formViewModel.inlineErrorForEmail).foregroundColor(.red)) {
//                            TextField("Email", text: $formViewModel.email)
//                                .autocapitalization(.none)
//                        }
    
//                        Section(header: Text("PASSWORD"), footer: Text(formViewModel.inlineErrorForPassword).foregroundColor(.red)) {
//                            SecureField("Password", text: $formViewModel.password)
//                            SecureField("Confirm Password", text: $formViewModel.confirmPassword)
//                        }
                    Button(action: {
                        let accountData = RegisterModel(username: formViewModel.username, email: formViewModel.email, password: formViewModel.password)
                        SignUpViewModel.shared.createData(reigsterModel: accountData)
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
                }
            }
    }
}

#Preview {
    SignUpView()
}
