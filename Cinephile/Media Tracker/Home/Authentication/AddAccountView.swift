import SwiftUI
import Networking
import Models
import SafariServices
import AuthenticationServices
import AppAccount

@MainActor
struct AddAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession

    @Environment(AppAccountsManager.self) private var appAccountsManager
    @StateObject private var formViewModel = FormViewModel()


    @State private var signInClient: Client?
    @State private var instance: Instance?
    @State private var isSigninIn  = false
    @State private var instanceFetchError: String?
    
    private let instanceName: String = "polar-brushlands-19893-4c4dfbb9419d.herokuapp.com"
    
    var body: some View {
        NavigationStack {
            VStack {
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
                            
                            Button(action: {
                                withAnimation {
                                    isSigninIn = true
                                }
                                Task {
                                    await signIn()
                                }
                            }) {
                                Text("Already have an account? Login")
                            }
                            .padding()
                        }
                        }
                    }
               }
                .task {
                    let client = Client(server: instanceName)
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
//        Task {
//          pushNotifications.setAccounts(accounts: appAccountsManager.pushAccounts)
//          await pushNotifications.updateSubscriptions(forceCreate: true)
//        }
        isSigninIn = false
        dismiss()
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

