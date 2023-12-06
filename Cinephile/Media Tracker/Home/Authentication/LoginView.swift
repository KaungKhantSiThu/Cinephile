//import SwiftUI
//
//struct LoginView: View {
//    
//    @State private  var email = ""
//    @State private var password = ""
//    
//    var body: some View {
//        VStack (alignment: .leading) {
//            Text(
//        }
////        ZStack {
////            Color.white
////            RoundedRectangle(cornerRadius: 30, style: .continuous)
////                .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
////                .frame(width: 1000, height: 400)
////                .rotationEffect(.degrees(135))
////                .offset(y:-350)
////            
////            VStack(spacing: 20) {
////                Text("Welcome")
////                    .foregroundStyle(.white)
////                    .font(.system(size: 40, weight: .bold, design: .rounded))
////                    .offset(x: -100, y: -100)
////                
////                TextField("Email", text: $email)
////                    .foregroundColor(.white)
////                    .textFieldStyle(.plain)
////                    .placeholder(when: email.isEmpty) {
////                        Text("Email")
////                            .foregroundColor(.white)
////                            .bold()
////                    }
////                
////                Rectangle()
////                    .fill(LinearGradient(
////                        gradient: Gradient(colors: [.white, .pink]),
////                        startPoint: .leading,
////                        endPoint: .trailing
////                    ))
////                    .frame(width: 350, height: 2)
////                
////                Text("Invalid email address")
////                    .font(.footnote)
////                    .foregroundColor(.red)
////                
////                TextField("Password", text: $password)
////                    .foregroundColor(.white)
////                    .textFieldStyle(.plain)
////                    .placeholder(when: email.isEmpty) {
////                        Text("Password")
////                            .foregroundColor(.white)
////                            .bold()
////                    }
////                
////                Rectangle()
////                    .fill(LinearGradient(
////                        gradient: Gradient(colors: [.white, .pink]),
////                        startPoint: .leading,
////                        endPoint: .trailing
////                    ))
////                    .frame(width: 350, height: 2)
////                
////                Button {
////                    
////                } label: {
////                    Text("Login")
////                        .bold()
////                        .frame(width: 200, height: 40)
////                        .background(
////                            RoundedRectangle(cornerRadius: 10, style: .continuous)
////                                .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
////                        )
////                        .foregroundColor(.white)
////                }
////                .padding(.top, 40)
////            }
////            .frame(width: 350)
////        }
////        .ignoresSafeArea()
//    }
//}
//
//#Preview {
//    LoginView()
//}
//
//extension View {
//    func placeholder<Content: View>(
//        when shouldShow: Bool,
//        alignment: Alignment = .leading,
//        @ViewBuilder placeholder: () -> Content) -> some View {
//
//        ZStack(alignment: alignment) {
//            placeholder().opacity(shouldShow ? 1 : 0)
//            self
//        }
//    }
//}

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

