////
////  ProfileView.swift
////  TMDB Test
////
////  Created by Kaung Khant Si Thu on 04/11/2023.
////
//
//import SwiftUI
//import SDWebImageSwiftUI
//
//enum ProfileViewCategory: String, Equatable, CaseIterable {
//    case posts = "My Posts"
//    case list = "Watch List"
//    
//    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
//}
//
//struct ProfileView: View {
//    @State private var category: ProfileViewCategory = .posts
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(alignment: .center) {
//                    WebImage(url: URL(string: "https://picsum.photos/seed/picsum/200"))
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(height: 100)
//                        .clipShape(
//                            Circle()
//                        )
//                    
//                    VStack(alignment: .leading) {
//                        Text("Mg Kaung")
//                            .font(.title)
//                            .foregroundStyle(.primary)
//                        Text("@mgkaung")
//                            .font(.subheadline)
//                            .foregroundStyle(.secondary)
//                    }
//                    
//                    HStack(spacing: 20) {
//                        VStack {
//                            Text("4")
//                                .font(.title2)
//                                .fontWeight(.bold)
//                            Text("Posts")
//                                .font(.caption)
//                        }
//                        
//                        VStack {
//                            Text("20")
//                                .font(.title2)
//                                .fontWeight(.bold)
//                            Text("Following")
//                                .font(.caption)
//                        }
//                        
//                        VStack {
//                            Text("15")
//                                .font(.title2)
//                                .fontWeight(.bold)
//                            Text("Followers")
//                                .font(.caption)
//                        }
//                    }
//                    .padding(.top, 20)
//                    
//                    Picker("", selection: $category) {
//                        ForEach(ProfileViewCategory.allCases, id: \.self) {
//                            Text($0.rawValue)
//                        }
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                    .padding(20)
//                    
//                    switch category {
//                    case .posts:
//                        Text("Some View")
//                    case .list:
//                        Text("Some View")
//                    }
//                }
//                .toolbar {
//                    ToolbarItem(placement: .topBarTrailing) {
//                        Button("Edit", action: {
//                            print("Edited")
//                        })
//                    }
//                    
//                    ToolbarItem(placement: .topBarTrailing) {
//                        Button("Settings", systemImage: "gearshape.fill") {
//                            print("setting")
//                        }
//                        .foregroundStyle(.primary)
//                    }
//                }
//                Spacer()
//            }
//        }
//    }
//}
//
//#Preview {
//    ProfileView()
//}
//
