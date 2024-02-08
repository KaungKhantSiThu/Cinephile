//
//  EditAccountView.swift
//
//
//  Created by Kaung Khant Si Thu on 17/12/2023.
//

//import SwiftUI
//import Networking
//import Environment
//import Models
//import CinephileUI
//import Status
//import OSLog
//
//private let logger = Logger(subsystem: "Account", category: "EditAccountView")
//@MainActor
//public struct EditAccountView: View {
//    @Environment(\.dismiss) private var dismiss
//    @Environment(Client.self) private var client
//    @Environment(Theme.self) private var theme
//    @Environment(UserPreferences.self) private var userPreferences
//    
//    @State private var viewModel = EditAccountViewModel()
//    
//    @State private var fieldsChange = false
//    
//    public init() {}
//    
//    public var body: some View {
//        NavigationStack{
//            Form {
//                if viewModel.isLoading {
//                    loadingSection
//                } else {
//                    aboutSections
//                    fieldsSection
//                    postSettingsSection
//                    accountSection
//                }
//            }
//            .environment(\.editMode, .constant(.active))
//            .scrollContentBackground(.hidden)
//            .scrollDismissesKeyboard(.immediately)
//            .navigationTitle(Text("account.edit.navigation-title", bundle: .module))
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                toolbarContent
//            }
//            .alert(Text("account.edit.error.save.title", bundle: .module),
//                   isPresented: $viewModel.saveError,
//                   actions: {
//                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//                    Text("alert.button.ok", bundle: .module)
//                })
//            },
//                   message: { Text("account.edit.error.save.message", bundle: .module) })
//            .task {
//                viewModel.client = client
//                await viewModel.fetchAccount()
//            }
//        }
//    }
//    
//    private var loadingSection: some View {
//        Section {
//            HStack {
//                Spacer()
//                ProgressView()
//                Spacer()
//            }
//        }
////        .listRowBackground(theme.primaryBackgroundColor)
//    }
//    
//    @ViewBuilder
//    private var aboutSections: some View {
//        List {
//            Section {
//                EditableCircularProfileImage(viewModel: $viewModel)
//            } header: {
//                Text("account.edit.avatar", bundle: .module)
//            }
//            .onChange(of: viewModel.imageSelection) {
//                fieldsChange = true
//            }
//        
//            Section {
//                
//                TextField(text: $viewModel.displayName) {
//                    Text("account.edit.display-name", bundle: .module)
//                }
//                .onSubmit {
//                    fieldsChange = true
//                }
//            } header: {
//                Text("account.edit.display-name", bundle: .module)
//            }
//                .listRowBackground(theme.primaryBackgroundColor)
//            
//            
//            Section {
//                TextField(text: $viewModel.note, axis: .vertical) {
//                    Text("account.edit.about", bundle: .module)
//                }.background(.red)
//                .onSubmit {
//                    fieldsChange = true
//                }
//                .frame(maxHeight: 150)
//            } header: {
//                Text("account.edit.about", bundle: .module)
//            }
//            
//
////                .listRowBackground(theme.primaryBackgroundColor)
//        }
//    }
//    
//    private var postSettingsSection: some View {
//        Section {
//            if !userPreferences.useInstanceContentSettings {
//                Text("account.edit.post-settings.content-settings-reference", bundle: .module)
//            }
//            
//            Picker(selection: $viewModel.postPrivacy) {
//                ForEach(Models.Visibility.supportDefault, id: \.rawValue) { privacy in
//                    Text(privacy.title, bundle: .module).tag(privacy)
//                }
//            } label: {
//                Label(
//                    title: { Text("account.edit.post-settings.privacy", bundle: .module) },
//                    icon: { Image(systemName: "lock") }
//                )
//            }
//            .pickerStyle(.menu)
//            .onChange(of: viewModel.postPrivacy) {
//                fieldsChange = true
//            }
//            
//            
//            Toggle(isOn: $viewModel.isSensitive) {
//                Label(
//                    title: { Text("account.edit.post-settings.sensitive", bundle: .module) },
//                    icon: { Image(systemName: "eye") }
//                )
//            }
//        } header: {
//            Text("account.edit.post-settings.section-title", bundle: .module)
//        }
//        .onChange(of: viewModel.isSensitive) {
//            fieldsChange = true
//        }
//    }
//    
//    private var accountSection: some View {
//        Section {
//            Toggle(isOn: $viewModel.isLocked) {
//                Label(
//                    title: { Text("account.edit.account-settings.private", bundle: .module) },
//                    icon: { Image(systemName: "lock") }
//                )
//            }
//            .onChange(of: viewModel.isLocked) {
//                fieldsChange = true
//            }
//            
//            Toggle(isOn: $viewModel.isBot) {
//                Label(
//                    title: { Text("account.edit.account-settings.bot", bundle: .module) },
//                    icon: { Image(systemName: "laptopcomputer.trianglebadge.exclamationmark") }
//                )
//            }
//            .onChange(of: viewModel.isBot) {
//                fieldsChange = true
//            }
//            
//            Toggle(isOn: $viewModel.isDiscoverable) {
//                Label(
//                    title: { Text("account.edit.account-settings.discoverable", bundle: .module) },
//                    icon: { Image(systemName: "magnifyingglass") }
//                )
//            }
//            .onChange(of: viewModel.isDiscoverable) {
//                fieldsChange = true
//            }
//            
//        } header: {
//            Text("account.edit.account-settings.section-title", bundle: .module)
//        }
////        .listRowBackground(theme.primaryBackgroundColor)
//    }
//    
//    private var fieldsSection: some View {
//        Section {
//            ForEach($viewModel.fields) { $field in
//                VStack(alignment: .leading) {
//                    TextField(text: $field.name) {
//                        Text("account.edit.metadata-name-placeholder", bundle: .module)
//                    }
//                    .font(.scaledHeadline)
//                    TextField(text: $field.value) {
//                        Text("account.edit.metadata-value-placeholder", bundle: .module)
//                    }
//                    .emojiSize(Font.scaledBodyFont.emojiSize)
//                    .emojiBaselineOffset(Font.scaledBodyFont.emojiBaselineOffset)
////                    .foregroundColor(theme.tintColor)
//                }
//            }
//            .onMove(perform: { indexSet, newOffset in
//                viewModel.fields.move(fromOffsets: indexSet, toOffset: newOffset)
//            })
//            .onDelete { indexes in
//                if let index = indexes.first {
//                    viewModel.fields.remove(at: index)
//                }
//            }
//            if viewModel.fields.count < 4 {
//                Button {
//                    withAnimation {
//                        viewModel.fields.append(.init(name: "", value: ""))
//                    }
//                } label: {
//                    Text("account.edit.add-metadata-button", bundle: .module)
////                        .foregroundColor(theme.tintColor)
//                }
//            }
//        } header: {
//            Text("account.edit.metadata-section-title", bundle: .module)
//        }
////        .listRowBackground(theme.primaryBackgroundColor)
//        .onChange(of: viewModel.fields) {
//            fieldsChange = true
//        }
//    }
//    
//    @ToolbarContentBuilder
//    private var toolbarContent: some ToolbarContent {
//        ToolbarItem(placement: .navigationBarLeading) {
//            Button {
//                dismiss()
//            } label: {
//                Text("action.cancel", bundle: .module)
//            }
//        }
//        
//        ToolbarItem(placement: .navigationBarTrailing) {
//            Button {
//                Task {
//                    await viewModel.save()
//                    dismiss()
//                }
//            } label: {
//                if viewModel.isSaving {
//                    ProgressView()
//                } else {
//                    Text("action.save", bundle: .module)
//                        .bold()
//                }
//            }
//            .disabled(fieldsChange == false)
//        }
//    }
//}

import Models
import Network
import SwiftUI
import NukeUI
import Networking
import Environment
import CinephileUI
import Status
import OSLog

@MainActor
public struct EditAccountView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(Client.self) private var client
  @Environment(Theme.self) private var theme
@Environment(UserPreferences.self) private var userPreferences

  @State private var viewModel = EditAccountViewModel()
    @State private var fieldsChange = false
  
  public init() { }

  public var body: some View {
    NavigationStack {
      Form {
        if viewModel.isLoading {
          loadingSection
        } else {
          imagesSection
          aboutSection
          fieldsSection
          postSettingsSection
          accountSection
        }
      }
      .environment(\.editMode, .constant(.active))
      #if !os(visionOS)
      .scrollContentBackground(.hidden)
      .background(.gray.opacity(0.3))
      .scrollDismissesKeyboard(.immediately)
      #endif
      .navigationTitle(Text("account.edit.navigation-title", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        toolbarContent
      }
      .alert("account.edit.error.save.title",
             isPresented: $viewModel.saveError,
             actions: {
               Button("alert.button.ok", action: {})
      }, message: { Text("account.edit.error.save.message", bundle: .module) })
      .task {
        viewModel.client = client
        await viewModel.fetchAccount()
      }
    }
  }

  private var loadingSection: some View {
    Section {
      HStack {
        Spacer()
        ProgressView()
        Spacer()
      }
    }
    #if !os(visionOS)
    .listRowBackground(theme.primaryBackgroundColor)
    #endif
  }
  
  private var imagesSection: some View {
      Section {
          EditableCircularProfileImage(viewModel: $viewModel)
      } header: {
          Text("account.edit.avatar", bundle: .module)
      }
  }

  @ViewBuilder
  private var aboutSection: some View {
      Section {

          TextField(text: $viewModel.displayName) {
              Text("account.edit.display-name", bundle: .module)
          }
      } header: {
          Text("account.edit.display-name", bundle: .module)
      }
          .listRowBackground(theme.primaryBackgroundColor)
      Section {
          TextField(text: $viewModel.note, axis: .vertical) {
              Text("account.edit.about", bundle: .module)
          }
          .frame(maxHeight: 150)
      } header: {
          Text("account.edit.about", bundle: .module)
      }
      .listRowBackground(theme.primaryBackgroundColor)
  }

  private var postSettingsSection: some View {
              Section {
                  if !userPreferences.useInstanceContentSettings {
                      Text("account.edit.post-settings.content-settings-reference", bundle: .module)
                  }
      
                  Picker(selection: $viewModel.postPrivacy) {
                      ForEach(Models.Visibility.supportDefault, id: \.rawValue) { privacy in
                          Text(privacy.title, bundle: .module).tag(privacy)
                      }
                  } label: {
                      Label(
                          title: { Text("account.edit.post-settings.privacy", bundle: .module) },
                          icon: { Image(systemName: "lock") }
                      )
                  }
                  .pickerStyle(.menu)
                  .onChange(of: viewModel.postPrivacy) {
                      fieldsChange = true
                  }
      
      
                  Toggle(isOn: $viewModel.isSensitive) {
                      Label(
                          title: { Text("account.edit.post-settings.sensitive", bundle: .module) },
                          icon: { Image(systemName: "eye") }
                      )
                  }
              } header: {
                  Text("account.edit.post-settings.section-title", bundle: .module)
              }
              .onChange(of: viewModel.isSensitive) {
                  fieldsChange = true
              }
  }

  private var accountSection: some View {
              Section {
                  Toggle(isOn: $viewModel.isLocked) {
                      Label(
                          title: { Text("account.edit.account-settings.private", bundle: .module) },
                          icon: { Image(systemName: "lock") }
                      )
                  }
                  .onChange(of: viewModel.isLocked) {
                      fieldsChange = true
                  }
      
                  Toggle(isOn: $viewModel.isBot) {
                      Label(
                          title: { Text("account.edit.account-settings.bot", bundle: .module) },
                          icon: { Image(systemName: "laptopcomputer.trianglebadge.exclamationmark") }
                      )
                  }
                  .onChange(of: viewModel.isBot) {
                      fieldsChange = true
                  }
      
                  Toggle(isOn: $viewModel.isDiscoverable) {
                      Label(
                          title: { Text("account.edit.account-settings.discoverable", bundle: .module) },
                          icon: { Image(systemName: "magnifyingglass") }
                      )
                  }
                  .onChange(of: viewModel.isDiscoverable) {
                      fieldsChange = true
                  }
      
              } header: {
                  Text("account.edit.account-settings.section-title", bundle: .module)
              }
              .listRowBackground(theme.primaryBackgroundColor)
  }

  private var fieldsSection: some View {
      Section {
                  ForEach($viewModel.fields) { $field in
                      VStack(alignment: .leading) {
                          TextField(text: $field.name) {
                              Text("account.edit.metadata-name-placeholder", bundle: .module)
                          }
                          .font(.scaledHeadline)
                          TextField(text: $field.value) {
                              Text("account.edit.metadata-value-placeholder", bundle: .module)
                          }
                          .emojiSize(Font.scaledBodyFont.emojiSize)
                          .emojiBaselineOffset(Font.scaledBodyFont.emojiBaselineOffset)
      //                    .foregroundColor(theme.tintColor)
                      }
                  }
                  .onMove(perform: { indexSet, newOffset in
                      viewModel.fields.move(fromOffsets: indexSet, toOffset: newOffset)
                  })
                  .onDelete { indexes in
                      if let index = indexes.first {
                          viewModel.fields.remove(at: index)
                      }
                  }
                  if viewModel.fields.count < 4 {
                      Button {
                          withAnimation {
                              viewModel.fields.append(.init(name: "", value: ""))
                          }
                      } label: {
                          Text("account.edit.add-metadata-button", bundle: .module)
      //                        .foregroundColor(theme.tintColor)
                      }
                  }
              } header: {
                  Text("account.edit.metadata-section-title", bundle: .module)
              }
      //        .listRowBackground(theme.primaryBackgroundColor)
              .onChange(of: viewModel.fields) {
                  fieldsChange = true
              }
  }

  @ToolbarContentBuilder
  private var toolbarContent: some ToolbarContent {
    CancelToolbarItem()

    ToolbarItem(placement: .navigationBarTrailing) {
      Button {
        Task {
          await viewModel.save()
          dismiss()
        }
      } label: {
        if viewModel.isSaving {
          ProgressView()
        } else {
            Text("action.save", bundle: .module).bold()
        }
      }
    }
  }
}

