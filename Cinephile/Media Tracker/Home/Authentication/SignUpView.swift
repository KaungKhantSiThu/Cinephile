//
//  SignupView.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 28/12/2023.
//

import SwiftUI
import Networking
import Models

struct SignUpView: View {
    
    @StateObject private var formViewModel = FormViewModel()
    @Environment(Client.self) private var client: Client
//    Client(server: "polar-brushlands-19893-4c4dfbb9419d.herokuapp.com", oauthToken: OauthToken(
//        accessToken: "IFLrywlcgH7FibvKOdS31C8FazkSDIYtCT2HQftv5ZY",
//        tokenType: "Bearer",
//        scope: "read write follow",
//        createdAt: 1705756054))
    //    @State private var instance: Instance?
    //    @State private var instanceFetchError: String?
    @State private var isSigningUp = false
    private let instanceName: String = "polar-brushlands-19893-4c4dfbb9419d.herokuapp.com"
    var body: some View {
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
            Button{
                let accountData = AccountData(
                    username: formViewModel.username,
                    email: formViewModel.email,
                    password: formViewModel.password)
                
                Task {
                    do {
                        let token = try await client.registerAccount(data: accountData)
                        print(token)
                    } catch {
                        print("Printing error description")
                        print(error.localizedDescription)
                    }
                    
                }
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 60)
                    .overlay(
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    )
            }
            .padding()
            .disabled(!formViewModel.isValid)
        }
//        .task {
//            print(try? await client.oauthURL())
//        }
    }
    
    
}

#Preview {
    SignUpView()
}
