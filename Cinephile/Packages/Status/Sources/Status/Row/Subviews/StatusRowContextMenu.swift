import CinephileUI
import Environment
import Foundation
import Networking
import SwiftUI
import Models

@MainActor
struct StatusRowContextMenu: View {
    @Environment(\.displayScale) var displayScale
    @Environment(\.openWindow) var openWindow
    
    @Environment(Client.self) private var client
    @Environment(SceneDelegate.self) private var sceneDelegate
    @Environment(UserPreferences.self) private var preferences
    @Environment(CurrentAccount.self) private var account
    @Environment(CurrentInstance.self) private var currentInstance
    @Environment(StatusDataController.self) private var statusDataController
    @Environment(QuickLook.self) private var quickLook
    @Environment(Theme.self) private var theme
    
    var viewModel: StatusRowViewModel
    @Binding var showTextForSelection: Bool
    
    var boostLabel: some View {
        if viewModel.status.visibility == .priv, viewModel.status.account.id == account.account?.id {
            
            if statusDataController.isReblogged {
                return Label {
                    Text("status.action.unboost", bundle: .module)
                } icon: {
                    Image(systemName: "lock.rotation")
                }
            }
            
            return Label {
                Text("status.action.boost-to-follower", bundle: .module)
            } icon: {
                Image(systemName: "lock.rotation")
            }
        }
        
        if statusDataController.isReblogged {
            return Label {
                Text("status.action.unboost", bundle: .module)
            } icon: {
                Image(systemName: "arrow.left.arrow.right")
            }
        }
        return Label {
            Text("status.action.boost", bundle: .module)
        } icon: {
            Image(systemName: "arrow.left.arrow.right")
        }
    }
    
    var body: some View {
        if !viewModel.isRemote, client.isAuth {
            
            Button {
#if targetEnvironment(macCatalyst)
                openWindow(value: WindowDestinationEditor.replyToStatusEditor(status: viewModel.status))
#else
                viewModel.routerPath.presentedSheet = .replyToStatusEditor(status: viewModel.status)
#endif
            } label: {
                Label {
                    Text("status.action.reply", bundle: .module)
                } icon: {
                    Image(systemName: "arrowshape.turn.up.left")
                }
            }
            
            Button {
#if targetEnvironment(macCatalyst)
                openWindow(value: WindowDestinationEditor.quoteStatusEditor(status: viewModel.status))
#else
                viewModel.routerPath.presentedSheet = .quoteStatusEditor(status: viewModel.status)
#endif
            } label: {
                Label {
                    Text("status.action.quote", bundle: .module)
                } icon: {
                    Image(systemName: "quote.bubble")
                }
            }
            .disabled(viewModel.status.visibility == .direct || viewModel.status.visibility == .priv)
        }
        
        Divider()
        
        Menu {
            if let urlString = viewModel.status.reblog?.url ?? viewModel.status.url, let url = URL(string: urlString) {
                ShareLink(item: url,
                          subject: Text(viewModel.status.reblog?.account.safeDisplayName ?? viewModel.status.account.safeDisplayName),
                          message: Text(viewModel.status.reblog?.content.asRawText ?? viewModel.status.content.asRawText))
                {
                    Label {
                        Text("status.action.share", bundle: .module)
                    } icon: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                
                ShareLink(item: url) {
                    Label {
                        Text("status.action.share-link", bundle: .module)
                    } icon: {
                        Image(systemName: "link")
                    }
                }
            }
        } label: {
            Text("status.action.share-title", bundle: .module)
        }
        
        //        if let url = URL(string: viewModel.status.reblog?.url ?? viewModel.status.url ?? "") {
        //            Button { UIApplication.shared.open(url) } label: {
        //                Label(
        //                    title: { Text("status.action.view-in-browser", bundle: .module) },
        //                    icon: { Image(systemName: "safari") }
        //                )
        //            }
        //        }
        
        Button {
            UIPasteboard.general.string = viewModel.status.reblog?.content.asRawText ?? viewModel.status.content.asRawText
        } label: {
            Label(
                title: { Text("status.action.copy-text", bundle: .module) },
                icon: { Image(systemName: "doc.on.doc") }
            )
        }
        
        Button {
            showTextForSelection = true
        } label: {
            Label(
                title: { Text("status.action.select-text", bundle: .module) },
                icon: { Image(systemName: "selection.pin.in.out") }
            )
        }
        
        //        Button {
        //            UIPasteboard.general.string = viewModel.status.reblog?.url ?? viewModel.status.url
        //        } label: {
        //            Label(
        //                title: { Text("status.action.copy-link", bundle: .module) },
        //                icon: { Image(systemName: "link") }
        //            )
        //        }
        
        //    if let lang = preferences.serverPreferences?.postLanguage ?? Locale.current.language.languageCode?.identifier {
        //      Button {
        //        Task {
        //          await viewModel.translate(userLang: lang)
        //        }
        //      } label: {
        //        Label("status.action.translate", systemImage: "captions.bubble")
        //      }
        //    }
        
        if account.account?.id == viewModel.status.reblog?.account.id ?? viewModel.status.account.id {
            Section("Your post") {
                
                Button {
                    Task {
                        if viewModel.isPinned {
                            await viewModel.unPin()
                        } else {
                            await viewModel.pin()
                        }
                    }
                } label: {
                    Label(
                        title: { Text(viewModel.isPinned ? "status.action.unpin" : "status.action.pin", bundle: .module) },
                        icon: { Image(systemName: viewModel.isPinned ? "pin.fill" : "pin") }
                    )
                }
                
                if currentInstance.isEditSupported {
                    Button {
#if targetEnvironment(macCatalyst)
                        openWindow(value: WindowDestinationEditor.editStatusEditor(status: viewModel.status.reblogAsAsStatus ?? viewModel.status))
#else
                        viewModel.routerPath.presentedSheet = .editStatusEditor(status: viewModel.status.reblogAsAsStatus ?? viewModel.status)
#endif
                    } label: {
                        Label(
                            title: { Text("status.action.edit", bundle: .module) },
                            icon: { Image(systemName: "pencil") }
                        )
                    }
                }
                
                Button(role: .destructive,
                       action: { viewModel.showDeleteAlert = true },
                       label: {
                    Label(
                        title: { Text("status.action.delete", bundle: .module) },
                        icon: { Image(systemName: "trash") }
                    )
                }
                )
            }
        } else {
            if !viewModel.isRemote, client.isAuth {
                Section(viewModel.status.reblog?.account.acct ?? viewModel.status.account.acct) {
                    Button {
                        viewModel.routerPath.presentedSheet = .mentionStatusEditor(account: viewModel.status.reblog?.account ?? viewModel.status.account, visibility: .pub)
                    } label: {
                        Label(
                            title: { Text("status.action.mention", bundle: .module) },
                            icon: { Image(systemName: "at") }
                        )
                    }
                    Button {
                        viewModel.routerPath.presentedSheet = .mentionStatusEditor(account: viewModel.status.reblog?.account ?? viewModel.status.account, visibility: .direct)
                    } label: {
                        Label(
                            title: { Text("status.action.message", bundle: .module) },
                            icon: { Image(systemName: "tray.full") }
                        )
                    }
                    
                    if viewModel.authorRelationship?.blocking == true {
                        Button {
                            Task {
                                do {
                                    let operationAccount = viewModel.status.reblog?.account ?? viewModel.status.account
                                    viewModel.authorRelationship = try await client.post(endpoint: Accounts.unblock(id: operationAccount.id))
                                } catch {
                                    print("Error while unblocking: \(error.localizedDescription)")
                                }
                            }
                        } label: {
                            Label(
                                title: { Text("status.action.unblock", bundle: .module) },
                                icon: { Image(systemName: "slash.circle.fill") }
                            )
                        }
                    } else {
                        Button {
                            Task {
                                do {
                                    let operationAccount = viewModel.status.reblog?.account ?? viewModel.status.account
                                    viewModel.authorRelationship = try await client.post(endpoint: Accounts.block(id: operationAccount.id))
                                } catch {
                                    print("Error while blocking: \(error.localizedDescription)")
                                }
                            }
                        } label: {
                            Label {
                                Text("status.action.block", bundle: .module)
                            } icon: {
                                Image(systemName: "slash.circle.fill")
                            }
                            
                            
                        }
                    }
                    
                    
                }
                
                if viewModel.authorRelationship?.muting == true {
                    Button {
                        Task {
                            do {
                                let operationAccount = viewModel.status.reblog?.account ?? viewModel.status.account
                                viewModel.authorRelationship = try await client.post(endpoint: Accounts.unmute(id: operationAccount.id))
                            } catch {
                                print("Error while unmuting: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        Label {
                            Text("status.action.unmute", bundle: .module)
                        } icon: {
                            Image(systemName: "speaker")
                        }
                    }
                } else {
                    Menu {
                        ForEach(Duration.mutingDurations(), id: \.rawValue) { duration in
                            Button {
                                Task {
                                    do {
                                        let operationAccount = viewModel.status.reblog?.account ?? viewModel.status.account
                                        viewModel.authorRelationship = try await client.post(endpoint: Accounts.mute(id: operationAccount.id, json: MuteData(duration: duration.rawValue)))
                                    } catch {
                                        print("Error while muting: \(error.localizedDescription)")
                                    }
                                }
                            } label: {
                                Text(duration.description, bundle: .module)
                            }
                        }
                    } label: {
                        Label {
                            Text("status.action.mute", bundle: .module)
                        } icon: {
                            Image(systemName: "speaker.slash")
                        }
                    }
                }
            }
            Section {
                Button(role: .destructive) {
                    viewModel.routerPath.presentedSheet = .report(status: viewModel.status.reblogAsAsStatus ?? viewModel.status)
                } label: {
                    Label(
                        title: { Text("status.action.report", bundle: .module) },
                        icon: { Image(systemName: "exclamationmark.bubble") }
                    )
                }
            }
        }
    }
}
