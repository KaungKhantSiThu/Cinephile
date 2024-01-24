import CinephileUI
import Environment
//import GiphyUISDK
import Models
import NukeUI
import PhotosUI
import SwiftUI
import TrackerUI

extension StatusEditor {
    @MainActor
    struct AccessoryView: View {
        @Environment(UserPreferences.self) private var preferences
        @Environment(Theme.self) private var theme
        @Environment(CurrentInstance.self) private var currentInstance
        @Environment(\.colorScheme) private var colorScheme
        
        @FocusState<UUID?>.Binding var isSpoilerTextFocused: UUID?
        let viewModel: ViewModel
        //  @Binding var followUpSEVMs: [StatusEditorViewModel]
        
        @State private var isDraftsSheetDisplayed: Bool = false
        @State private var isLanguageSheetDisplayed: Bool = false
        @State private var isCustomEmojisSheetDisplay: Bool = false
        @State private var languageSearch: String = ""
        @State private var isLoadingAIRequest: Bool = false
        @State private var isPhotosPickerPresented: Bool = false
        @State private var isFileImporterPresented: Bool = false
        @State private var isCameraPickerPresented: Bool = false
        @State private var isTrackerMediaPickerSheetDisplay: Bool = false
        //  @State private var isGIFPickerPresented: Bool = false
        @State private var model = TrackerExploreViewModel()

        var body: some View {
            @Bindable var viewModel = viewModel
            
            VStack(spacing: 0) {
                Divider()
                HStack {
                    ScrollView(.horizontal) {
                        HStack(alignment: .center, spacing: 16) {
                            Menu {
                                Button {
                                    isPhotosPickerPresented = true
                                } label: {
                                    Label {
                                        Text("status.editor.photo-library", bundle: .module)
                                    } icon: {
                                        Image(systemName: "photo")
                                    }
                                }
                                
#if !targetEnvironment(macCatalyst)
                                Button {
                                    isCameraPickerPresented = true
                                } label: {
                                    Label {
                                        Text("status.editor.camera-picker", bundle: .module)
                                    } icon: {
                                        Image(systemName: "camera")
                                    }
                                }
#endif
                                Button {
                                    isFileImporterPresented = true
                                } label: {
                                    Label {
                                        Text("status.editor.browse-file", bundle: .module)
                                    } icon: {
                                        Image(systemName: "folder")
                                    }
                                }
                                
                                //              Button {
                                //                isGIFPickerPresented = true
                                //              } label: {
                                //                Label("GIPHY", systemImage: "party.popper")
                                //              }
                            } label: {
                                if viewModel.isMediasLoading {
                                    ProgressView()
                                } else {
                                    Image(systemName: "photo.on.rectangle.angled")
                                }
                            }
                            .photosPicker(isPresented: $isPhotosPickerPresented,
                                          selection: $viewModel.mediaPickers,
                                          maxSelectionCount: 4,
                                          matching: .any(of: [.images, .videos]),
                                          photoLibrary: .shared())
                            .fileImporter(isPresented: $isFileImporterPresented,
                                          allowedContentTypes: [.image, .video],
                                          allowsMultipleSelection: true)
                            { result in
                                if let urls = try? result.get() {
                                    viewModel.processURLs(urls: urls)
                                }
                            }
                            .fullScreenCover(isPresented: $isCameraPickerPresented, content: {
                                CameraPickerView(selectedImage: .init(get: {
                                    nil
                                }, set: { image in
                                    if let image {
                                        viewModel.processCameraPhoto(image: image)
                                    }
                                }))
                                .background(.black)
                            })
                            //            .sheet(isPresented: $isGIFPickerPresented, content: {
                            //              GifPickerView { url in
                            //                GPHCache.shared.downloadAssetData(url) { data, _ in
                            //                  guard let data else { return }
                            //                  viewModel.processGIFData(data: data)
                            //                }
                            //                isGIFPickerPresented = false
                            //              } onShouldDismissGifPicker: {
                            //                isGIFPickerPresented = false
                            //              }
                            //              .presentationDetents([.medium, .large])
                            //            })
                            //            .accessibilityLabel("accessibility.editor.button.attach-photo")
                            .disabled(viewModel.showPoll)
                            
                            Button {
                                withAnimation {
                                    viewModel.showPoll.toggle()
                                    viewModel.resetPollDefaults()
                                }
                            } label: {
                                Image(systemName: "chart.bar")
                            }
                            .accessibilityLabel("accessibility.editor.button.poll")
                            .disabled(viewModel.shouldDisablePollButton)
                            
                            Button {
                                withAnimation {
                                    viewModel.spoilerOn.toggle()
                                }
                                isSpoilerTextFocused = viewModel.id
                            } label: {
                                Image(systemName: viewModel.spoilerOn ? "exclamationmark.triangle.fill" : "exclamationmark.triangle")
                            }
                            .accessibilityLabel("accessibility.editor.button.spoiler")
                            
                            if !viewModel.mode.isInShareExtension {
                                Button {
                                    isDraftsSheetDisplayed = true
                                } label: {
                                    Image(systemName: "archivebox")
                                }
                                .accessibilityLabel("accessibility.editor.button.drafts")
                                .popover(isPresented: $isDraftsSheetDisplayed) {
                                    if UIDevice.current.userInterfaceIdiom == .phone {
                                        draftsListView
                                            .presentationDetents([.medium])
                                    } else {
                                        draftsListView
                                            .frame(width: 400, height: 500)
                                    }
                                }
                            }
                            
                            if !viewModel.customEmojiContainer.isEmpty {
                                Button {
                                    isCustomEmojisSheetDisplay = true
                                } label: {
                                    // This is a workaround for an apparent bug in the `face.smiling` SF Symbol.
                                    // See https://github.com/Dimillian/IceCubesApp/issues/1193
                                    let customEmojiSheetIconName = colorScheme == .light ? "face.smiling" : "face.smiling.inverse"
                                    Image(systemName: customEmojiSheetIconName)
                                }
                                .accessibilityLabel("accessibility.editor.button.custom-emojis")
                                .popover(isPresented: $isCustomEmojisSheetDisplay) {
                                    if UIDevice.current.userInterfaceIdiom == .phone {
                                        customEmojisSheet
                                    } else {
                                        customEmojisSheet
                                            .frame(width: 400, height: 500)
                                    }
                                }
                            }
                            
                            Button {
                                isTrackerMediaPickerSheetDisplay.toggle()
                            } label: {
                                Image(systemName: "movieclapper")
                            }
                            .popover(isPresented: $isTrackerMediaPickerSheetDisplay) {
                                trackerMediaSheet
                            }
                            
                            //language button
                            Button {
                                isLanguageSheetDisplayed.toggle()
                            } label: {
                                if let language = viewModel.selectedLanguage {
                                    Text(language.uppercased())
                                } else {
                                    Image(systemName: "globe")
                                }
                            }
                            .accessibilityLabel("accessibility.editor.button.language")
                            .popover(isPresented: $isLanguageSheetDisplayed) {
                                if UIDevice.current.userInterfaceIdiom == .phone {
                                    languageSheetView
                                } else {
                                    languageSheetView
                                        .frame(width: 400, height: 500)
                                }
                            }
                            
                        }
                        .padding(.horizontal, .layoutPadding)
                    }
                    Spacer()
                    characterCountView
                        .padding(.trailing, .layoutPadding)
                }
                .frame(height: 20)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
            }
            .onAppear {
                viewModel.setInitialLanguageSelection(preference: preferences.recentlyUsedLanguages.first ?? preferences.serverPreferences?.postLanguage)
            }
        }
        
        
        private var draftsListView: some View {
            DraftsListView(selectedDraft: .init(get: {
                nil
            }, set: { draft in
                if let draft {
                    viewModel.insertStatusText(text: draft.content)
                }
            }))
        }
        
        @ViewBuilder
        private func languageTextView(isoCode: String, nativeName: String?, name: String?) -> some View {
            if let nativeName, let name {
                Text("\(nativeName) (\(name))", bundle: .module, comment: "Native name - Name for languages ")
            } else {
                Text("\(isoCode.uppercased())", bundle: .module)
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
                .searchable(text: $languageSearch)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            isLanguageSheetDisplayed = false
                        } label: {
                            Text("action.cancel", bundle: .module)
                        }
                    }
                }
                .navigationTitle(Text("status.editor.language-select.navigation-title", bundle: .module))
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
                //      .background(theme.secondaryBackgroundColor)
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
        
        private var trackerMediaSheet: some View {
            NavigationStack {
                List {
                    if !model.isSearchPresented {
                        switch model.state {
                        case .idle:
                            Color.clear.onAppear {
                                model.fetchTrending()
                            }
                        case .loading:
                            ProgressView()
                        case .failed(let error):
                            ContentUnavailableView("Fetching data failed", systemImage: "magnifyingglass", description: Text("Error: \(error.localizedDescription)"))
                                .symbolVariant(.slash)
                        case .loaded(let value):
                            Section {
                                ScrollView {
                                    VStack {
                                        ForEach(value.popularMovies) { movie in
                                            MediaRow(movie: movie) {
                                                viewModel.trackerMedia = TrackerMedia(
                                                    id: movie.id,
                                                    title: movie.title,
                                                    posterURL: movie.posterPath,
                                                    releasedDate: movie.releaseDate,
                                                    voteAverage: movie.voteAverage,
                                                    mediaType: .movie)
                                                
                                                isTrackerMediaPickerSheetDisplay = false
                                            }
                                        }
                                    }
                                }
                                .scrollIndicators(.hidden)
                            } header: {
                                Text("Trending Movies")
                                    .font(.title).bold()
                            }
                            
                            Section {
                                ScrollView {
                                    VStack {
                                        ForEach(value.popularTVSeries) { series in
                                            MediaRow(tvSeries: series) {
                                                viewModel.trackerMedia = TrackerMedia(
                                                    id: series.id,
                                                    title: series.name,
                                                    posterURL: series.posterPath,
                                                    releasedDate: series.firstAirDate,
                                                    voteAverage: series.voteAverage,
                                                    mediaType: .tvSeries)
                                                isTrackerMediaPickerSheetDisplay = false
                                            }
                                        }
                                    }
                                }
                                .scrollIndicators(.hidden)
                            } header: {
                                Text("Trending TV Series")
                                    .font(.title).bold()
                            }
                            
                            
                        }
                    }
                    
                    if !model.searchText.isEmpty {
                        ForEach(model.medias) {
                            media in
                            switch media {
                            case .movie(let movie):
                                MediaRow(movie: movie) {
                                    viewModel.trackerMedia = TrackerMedia(
                                        id: movie.id,
                                        title: movie.title,
                                        posterURL: movie.posterPath,
                                        releasedDate: movie.releaseDate,
                                        voteAverage: movie.voteAverage,
                                        mediaType: .movie)
                                    isTrackerMediaPickerSheetDisplay = false
                                }
                            case .tvSeries(let series):
                                MediaRow(tvSeries: series) {
                                    viewModel.trackerMedia = TrackerMedia(
                                        id: series.id,
                                        title: series.name,
                                        posterURL: series.posterPath,
                                        releasedDate: series.firstAirDate,
                                        voteAverage: series.voteAverage,
                                        mediaType: .tvSeries)
                                    isTrackerMediaPickerSheetDisplay = false
                                    print("")
                                }
                            case .person(_):
                                EmptyView()
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .searchable(text: $model.searchText,
                            isPresented: $model.isSearchPresented,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: Text("Search Movies, Series, Cast"))
                .task(id: model.searchText) {
                    do {
                        try await Task.sleep(for: .milliseconds(150))
                        try await model.search()
                    } catch {
                        print("Search Failed")
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            isTrackerMediaPickerSheetDisplay = false
                        } label: {
                            Text("action.cancel", bundle: .module)
                        }
                    }
                }
                //.background(theme.primaryBackgroundColor)
                .navigationTitle(Text("status.editor.tracker-media.navigation-title", bundle: .module))
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        
        
        private var customEmojisSheet: some View {
            NavigationStack {
                ScrollView {
                    ForEach(viewModel.customEmojiContainer) { container in
                        VStack(alignment: .leading) {
                            Text("\(container.categoryName)", bundle: .module)
                                .font(.scaledFootnote)
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], spacing: 9) {
                                ForEach(container.emojis) { emoji in
                                    LazyImage(url: emoji.url) { state in
                                        if let image = state.image {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 40, height: 40)
                                                .accessibilityLabel(emoji.shortcode.replacingOccurrences(of: "_", with: " "))
                                                .accessibilityAddTraits(.isButton)
                                        } else if state.isLoading {
                                            Rectangle()
                                                .fill(Color.gray)
                                                .frame(width: 40, height: 40)
                                                .accessibility(hidden: true)
                                            //                      .shimmering()
                                        }
                                    }
                                    .onTapGesture {
                                        viewModel.insertStatusText(text: " :\(emoji.shortcode): ")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            isCustomEmojisSheetDisplay = false
                        } label: {
                            Text("action.cancel", bundle: .module)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                //.background(theme.primaryBackgroundColor)
                .navigationTitle(Text("status.editor.emojis.navigation-title", bundle: .module))
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.medium])
        }
        
        @ViewBuilder
        private var characterCountView: some View {
            let value = (currentInstance.instance?.configuration?.statuses.maxCharacters ?? 500) + viewModel.statusTextCharacterLength
            
            Text("\(value)", bundle: .module)
                .foregroundColor(value < 0 ? .red : .secondary)
                .font(.scaledCallout)
            //      .accessibilityLabel("accessibility.editor.button.characters-remaining")
            //      .accessibilityValue("\(value)")
            //      .accessibilityRemoveTraits(.isStaticText)
            //      .accessibilityAddTraits(.updatesFrequently)
            //      .accessibilityRespondsToUserInteraction(false)
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
