//
//import SwiftUI
//
//struct SingupView: View {
//    
//    @State private  var email = ""
//    @State private var password = ""
//    @State private var firstName = ""
//    @State private var lastName = ""
//    @State private var dataOfBirth = ""
//    
//    var body: some View {
//        NavigationView{
//            ZStack {
//                Color.black
//                RoundedRectangle(cornerRadius: 30, style: .continuous)
//                    .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
//                    .frame(width: 1000, height: 400)
//                    .rotationEffect(.degrees(135))
//                    .offset(y:-350)
//                
//                VStack(spacing: 20) {
//                    Text("Welcome")
//                        .foregroundStyle(.white)
//                        .font(.system(size: 40, weight: .bold, design: .rounded))
//                        .offset(x: -100, y: -100)
//                    
//                    TextField("Name", text: $password)
//                        .foregroundColor(.white)
//                        .textFieldStyle(.plain)
//                        .placeholder(when: email.isEmpty) {
//                            Text("Name")
//                                .foregroundColor(.white)
//                                .bold()
//                        }
//                    
//                    Rectangle()
//                        .frame(width: 350, height: 1)
//                        .foregroundColor(.white)
//                    
//                    TextField("Email", text: $email)
//                        .foregroundColor(.white)
//                        .textFieldStyle(.plain)
//                        .placeholder(when: email.isEmpty) {
//                            Text("Email")
//                                .foregroundColor(.white)
//                                .bold()
//                        }
//                    
//                    Rectangle()
//                        .frame(width: 350, height: 1)
//                        .foregroundColor(.white)
//                    
//                    TextField("Password", text: $password)
//                        .foregroundColor(.white)
//                        .textFieldStyle(.plain)
//                        .placeholder(when: email.isEmpty) {
//                            Text("Password")
//                                .foregroundColor(.white)
//                                .bold()
//                        }
//                    
//                    Rectangle()
//                        .frame(width: 350, height: 1)
//                        .foregroundColor(.white)
//                    
//                    TextField("Date of Birth", text: $password)
//                        .foregroundColor(.white)
//                        .textFieldStyle(.plain)
//                        .placeholder(when: email.isEmpty) {
//                            Text("Date of Birth")
//                                .foregroundColor(.white)
//                                .bold()
//                        }
//                    
//                    Rectangle()
//                        .frame(width: 350, height: 1)
//                        .foregroundColor(.white)
//                    
//                    Button {
//                        
//                    } label: {
//                        Text("Sign up")
//                            .bold()
//                            .frame(width: 200, height: 40)
//                            .background(
//                                RoundedRectangle(cornerRadius: 10, style: .continuous)
//                                    .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
//                            )
//                            .foregroundColor(.white)
//                    }
//                    .padding(.top, 20)
//                    
////                    NavigationLink(destination: LoginView()) {
////                        Text("Already have an account? Login")
////                            .bold()
////                            .foregroundColor(.white)
////                            .underline()
////                    }
////                    .padding(.top)
////                    .offset(y: 110)
//                }
//                .frame(width: 350)
//            }
//                .ignoresSafeArea()
//        }
//    }
//}
//
//#Preview {
//    SingupView()
//}

import SwiftUI

struct SingupView: View {
    
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
                Button(action: {}) {
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
    SingupView()
}
