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

    @State private var signInClient: Client?
    @State private var instance: Instance?
    @State private var isSigninIn  = false
    @State private var instanceFetchError: String?
    
    private let instanceName: String = "polar-brushlands-19893-4c4dfbb9419d.herokuapp.com"

//    @StateObject private var formViewModel = FormViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: SignUpView()) {
                         Text("SignIn")
                             .padding()
                             .background(Color.blue)
                             .foregroundColor(.white)
                             .cornerRadius(10)
                     }
                     .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    withAnimation {
                        isSigninIn = true
                    }
                    Task {
                        await signIn()
                    }
                }) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 60)
                        .overlay(
                            Text("Login")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        )
                }
                .padding()
//                Form {
//                    Section(
//                        header: Text("EMAIL"),
//                        footer: Text(formViewModel.inlineErrorForEmail)
//                        .foregroundColor(.red)) 
//                    {
//                        TextField("Email", text: $formViewModel.email)
//                            .autocapitalization(.none)
//                    }
//                    
//                    Section(
//                        header: Text("PASSWORD"),
//                        footer: Text(formViewModel.inlineErrorForPassword)
//                            .foregroundColor(.red)) 
//                    {
//                        SecureField("Password", text: $formViewModel.password)
//                        SecureField("Confirm Password", text: $formViewModel.confirmPassword)
//                        
//                    }
               }
                .navigationTitle("Login")
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

