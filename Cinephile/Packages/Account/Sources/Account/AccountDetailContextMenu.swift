import Environment
import SwiftUI
import Networking

public struct AccountDetailContextMenu: View {
    @Environment(Client.self) private var client
    @Environment(RouterPath.self) private var routerPath
    //  @Environment(CurrentInstance.self) private var currentInstance
    @Environment(UserPreferences.self) private var preferences
    
    @Binding var showBlockConfirmation: Bool
    
    var viewModel: AccountDetailViewModel
    
    public var body: some View {
        if let account = viewModel.account {
            Section(account.acct) {
                if !viewModel.isCurrentUser {
                    
                    Button {
                        routerPath.presentedSheet = .mentionStatusEditor(account: account,
                                                                         visibility: preferences.postVisibility)
                    } label: {
                        Label("mention", systemImage: "at")
                    }
                    
                    
#if !targetEnvironment(macCatalyst)
                    Divider()
#endif
                    
                    if viewModel.relationship?.blocking == true {
                        Button {
                            Task {
                                do {
                                    viewModel.relationship = try await client.post(endpoint: Accounts.unblock(id: account.id))
                                } catch {}
                            }
                        } label: {
                            Label("unblock", systemImage: "slash.circle.fill")
                        }
                    } else {
                        Button {
                            showBlockConfirmation.toggle()
                        } label: {
                            Label("block", systemImage: "slash.circle.fill")
                        }
                    }
                    
//                    if viewModel.relationship?.muting == true {
//                        Button {
//                            Task {
//                                do {
//                                    viewModel.relationship = try await client.post(endpoint: Accounts.unmute(id: account.id))
//                                } catch {}
//                            }
//                        } label: {
//                            Label("account.action.unmute", systemImage: "speaker")
//                        }
//                    } else {
//                        Menu {
//                            ForEach(Duration.mutingDurations(), id: \.rawValue) { duration in
//                                Button(duration.description) {
//                                    Task {
//                                        do {
//                                            viewModel.relationship = try await client.post(endpoint: Accounts.mute(id: account.id, json: MuteData(duration: duration.rawValue)))
//                                        } catch {}
//                                    }
//                                }
//                            }
//                        } label: {
//                            Label("account.action.mute", systemImage: "speaker.slash")
//                        }
//                    }
                    
                    if let relationship = viewModel.relationship,
                       relationship.following
                    {
                        if relationship.notifying {
                            Button {
                                Task {
                                    do {
                                        viewModel.relationship = try await client.post(endpoint: Accounts.follow(id: account.id,
                                                                                                                 notify: false,
                                                                                                                 reblogs: relationship.showingReblogs))
                                    } catch {}
                                }
                            } label: {
                                Label("account.action.notify-disable", systemImage: "bell.fill")
                            }
                        } else {
                            Button {
                                Task {
                                    do {
                                        viewModel.relationship = try await client.post(endpoint: Accounts.follow(id: account.id,
                                                                                                                 notify: true,
                                                                                                                 reblogs: relationship.showingReblogs))
                                    } catch {}
                                }
                            } label: {
                                Label("Enable Notifications", systemImage: "bell")
                            }
                        }
                        if relationship.showingReblogs {
                            Button {
                                Task {
                                    do {
                                        viewModel.relationship = try await client.post(endpoint: Accounts.follow(id: account.id,
                                                                                                                 notify: relationship.notifying,
                                                                                                                 reblogs: false))
                                    } catch {}
                                }
                            } label: {
                                Label("Hide Reboost", image: "arrow.2.squarepath")
                            }
                        } else {
                            Button {
                                Task {
                                    do {
                                        viewModel.relationship = try await client.post(endpoint: Accounts.follow(id: account.id,
                                                                                                                 notify: relationship.notifying,
                                                                                                                 reblogs: true))
                                    } catch {}
                                }
                            } label: {
                                Label("account.action.reboosts-show", image: "Rocket")
                            }
                        }
                    }
                    
                }
            }
        }
    }
}
