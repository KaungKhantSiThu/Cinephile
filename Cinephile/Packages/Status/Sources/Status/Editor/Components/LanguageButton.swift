//
//  SwiftUIView.swift
//
//
//  Created by Kaung Khant Si Thu on 23/01/2024.
//

import CinephileUI
import Environment
import SwiftUI
import Models

extension StatusEditor.AccessoryView {
    
    @MainActor
    struct LanguageButton: View {
        @Environment(Theme.self) private var theme
        @Environment(CurrentInstance.self) private var currentInstance
        @Environment(UserPreferences.self) private var preferences
        
        @State private var isLanguageSheetDisplayed: Bool = false
        @State private var languageSearch: String = ""
        
        var viewModel: StatusEditor.ViewModel
        
        var body: some View {
            Button {
                isLanguageSheetDisplayed.toggle()
            } label: {
                if let language = viewModel.selectedLanguage {
                    Text(language.uppercased())
                } else {
                    Image(systemName: "globe")
                }
            }
            .buttonStyle(.bordered)
            .onAppear {
                viewModel.setInitialLanguageSelection(preference: preferences.recentlyUsedLanguages.first ?? preferences.serverPreferences?.postLanguage)
            }
            //      .accessibilityLabel("accessibility.editor.button.language")
            .sheet(isPresented: $isLanguageSheetDisplayed) {
                languageSheetView
            }
        }
        
        private var languageSheetView: some View {
            NavigationStack {
                List {
                    if languageSearch.isEmpty {
                        if !recentlyUsedLanguages.isEmpty {
                            Section {
                                languageSheetSection(languages: recentlyUsedLanguages)
                            } header: {
                                Text("status.editor.language-select.recently-used", bundle: .module)
                            }
                        }
                        Section {
                            languageSheetSection(languages: otherLanguages)
                        }
                    } else {
                        languageSheetSection(languages: languageSearchResult(query: languageSearch))
                    }
                }
                .searchable(text: $languageSearch, placement: .navigationBarDrawer)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button { isLanguageSheetDisplayed = false } label: {
                            Text("action.cancel", bundle: .module)
                        }
                    }
                }
                .navigationTitle(Text("status.editor.language-select.navigation-title", bundle: .module))
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
//                .background(theme.secondaryBackgroundColor)
            }
        }
        
        @ViewBuilder
        private func languageTextView(isoCode: String, nativeName: String?, name: String?) -> some View {
            if let nativeName, let name {
                Text("\(nativeName) (\(name))")
            } else {
                Text(isoCode.uppercased())
            }
        }
        
        private func languageSheetSection(languages: [Language]) -> some View {
            ForEach(languages) { language in
                HStack {
                    languageTextView(
                        isoCode: language.isoCode,
                        nativeName: language.nativeName,
                        name: language.localizedName
                    ).tag(language.isoCode)
                    Spacer()
                    if language.isoCode == viewModel.selectedLanguage {
                        Image(systemName: "checkmark")
                    }
                }
//                .listRowBackground(theme.primaryBackgroundColor)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.selectedLanguage = language.isoCode
                    viewModel.hasExplicitlySelectedLanguage = true
                    isLanguageSheetDisplayed = false
                }
            }
        }
        
        private var recentlyUsedLanguages: [Language] {
            preferences.recentlyUsedLanguages.compactMap { isoCode in
                Language.allAvailableLanguages.first { $0.isoCode == isoCode }
            }
        }
        
        private var otherLanguages: [Language] {
            Language.allAvailableLanguages.filter { !preferences.recentlyUsedLanguages.contains($0.isoCode) }
        }
        
        private func languageSearchResult(query: String) -> [Language] {
            Language.allAvailableLanguages.filter { language in
                guard !languageSearch.isEmpty else {
                    return true
                }
                return language.nativeName?.lowercased().hasPrefix(query.lowercased()) == true
                || language.localizedName?.lowercased().hasPrefix(query.lowercased()) == true
            }
        }
    }
}
