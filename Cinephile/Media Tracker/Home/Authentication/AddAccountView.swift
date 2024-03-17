import SwiftUI
import Networking
import Models
import SafariServices
import AuthenticationServices
import AppAccount
import Environment

@MainActor
struct AddAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @Environment(Client.self) private var client: Client
    @Environment(PushNotificationsService.self) private var pushNotifications
    @Environment(RouterPath.self) private var routerPath
    @Environment(AppAccountsManager.self) private var appAccountsManager
    @Environment(UserPreferences.self) private var preferences
    @StateObject private var formViewModel = FormViewModel()
    
    @State private var signInClient: Client?
    @State private var instance: Instance?
    @State private var isSigninIn  = false
    @State private var instanceFetchError: String?
    
    private let instanceName: String = "cinephile-social.me"

    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    //    @StateObject private var formViewModel = FormViewModel()
    enum FocusedField {
        case username, email, password, confirm
    }
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Cinephile")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(LinearGradient(colors: [.red, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .padding()
                
                VStack {
                    TextField("Username", text: $formViewModel.username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(10)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.indigo, lineWidth: focusedField == .username ? 2:  0)
                        )
                        .autocapitalization(.none)
                        .focused($focusedField, equals: .username)
                    
                    Text(formViewModel.inlineErrorForUsername)
                        .foregroundColor(.red)
                }
                
                
                VStack {
                    TextField("Email", text: $formViewModel.email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(10)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.indigo, lineWidth: focusedField == .email ? 2:  0)
                        )
                        .autocapitalization(.none)
                        .focused($focusedField, equals: .email)
                    
                    
                    Text(formViewModel.inlineErrorForEmail).foregroundColor(.red)
                }
                
                VStack {
                    SecureField("Password", text: $formViewModel.password)
                        .textContentType(.newPassword)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(10)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.indigo, lineWidth: focusedField == .password ? 2:  0)
                        )                        .autocapitalization(.none)
                        .focused($focusedField, equals: .password)
                    
                    
                    SecureField("Confirm Password", text: $formViewModel.confirmPassword)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(10)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.indigo, lineWidth: focusedField == .confirm ? 2:  0)
                        )                        .autocapitalization(.none)
                        .focused($focusedField, equals: .confirm)
                    
                    
                    Text(formViewModel.inlineErrorForPassword).foregroundColor(.red)
                    
                }
                
                Toggle(isOn: $formViewModel.agreement, label: {
                    Text("I have read and agree to Cinephile rules and privacy policy")
                })
                .frame(width: 300)
                .toggleStyle(CheckBoxToggleStyle())
                
                Button{
                    let accountData = AccountData(
                        username: formViewModel.username,
                        email: formViewModel.email,
                        password: formViewModel.password,
                        agreement: formViewModel.agreement)
                    
                    Task {
                        do {
                            let _ = try await client.registerAccount(data: accountData)
                            alertTitle = "Registration Successful"
                            alertMessage = "Please check your email inbox or spam folder"
                            showAlert = true
                            
                        } catch {
                            alertTitle = "Registration Failure"
                            if let error = error as? RegistrationError {
                                alertMessage = error.error
                            } else {
                                alertMessage = error.localizedDescription
                            }
                            showAlert = true
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
                .frame(width: 300, height: 80)
                .padding()
                .disabled(!formViewModel.isValid)
                
                Button(action: {
                    withAnimation {
                        isSigninIn = true
                    }
                    Task {
                        await signIn()
                    }
                }) {
                    Text("Already have an account? Login")
                        .foregroundStyle(.blue)
                }
                .padding()
            }
            .task {
                let client = Client(server: AppInfo.defaultServer)
                do {
                    let instance: Instance = try await client.get(endpoint: Instances.instance)
                    withAnimation {
                        self.instance = instance
                    }
                }  catch _ as DecodingError {
                    instance = nil
                    instanceFetchError = "Instance not supported"
                } catch {
                    instance = nil
                }
            }
            .onChange(of: scenePhase) { _, newValue in
                switch newValue {
                case .active:
                    isSigninIn = false
                default:
                    break
                }
            }
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK") {
                    // handle this
                }
            } message: {
                Text(alertMessage)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(Color.gray)
                            .frame(width: 40, height: 40)
                    }
                    
                }
            }
        }
    }
    
    private func signIn() async {
        signInClient = .init(server: instanceName)
        if let oauthURL = try? await signInClient?.oauthURL(),
           let url = try? await webAuthenticationSession.authenticate(using: oauthURL,
                                                                      callbackURLScheme: AppInfo.scheme.replacingOccurrences(of: "://", with: "")) {
            await continueSignIn(url: url)
        } else {
            isSigninIn = false
        }
    }
    
    private func continueSignIn(url: URL) async {
        guard let client = signInClient else {
            isSigninIn = false
            return
        }
        do {
            let oauthToken = try await client.continueOauthFlow(url: url)
            let client = Client(server: client.server, oauthToken: oauthToken)
            let account: Account = try await client.get(endpoint: Accounts.verifyCredentials)
            appAccountsManager.add(account: AppAccount(server: client.server,
                                                       accountName: "\(account.acct)@\(client.server)",
                                                       oauthToken: oauthToken))
            Task {
                pushNotifications.setAccounts(accounts: appAccountsManager.pushAccounts)
                await pushNotifications.updateSubscriptions(forceCreate: true)
            }
            isSigninIn = false
            //            dismiss()
//            if preferences.showGenresPicker {
                routerPath.presentedSheet = .genresPicker
//            }
        } catch {
            isSigninIn = false
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context _: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_: SFSafariViewController, context _: UIViewControllerRepresentableContext<SafariView>) {}
}

//#Preview {
//    LoginView()
//}

