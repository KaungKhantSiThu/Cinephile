//
//  SignupView.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 28/12/2023.
//

import SwiftUI

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
    SignUpView()
}
