import SwiftUI

struct PreferenceView: View {
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack {
                        Image("cinephile_icon")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .cornerRadius(20)

                        Text("Cinephile")
                            .font(.title2)
                            .bold()

                        Text("Version 1.0")
                            .foregroundColor(.secondary)

                        Text("Designed and developed with love \n by Cinephile Team")
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                        .padding()
                                        
                    VStack {
                        
                        NavigationLink {
                            AboutView()
                        } label: {
                            Label("Acknowledgements", imageNamed: "arrow.right.circle.fill")
                        }
                        .buttonStyle(.borderedProminent)


                        VStack {
                            Text("Sequel is made possible by these data sources")
                                .foregroundColor(.secondary)
                                .font(.caption2)
                            
                            Image("tmdb_logo")
                                .resizable()
                                .frame(width: 30, height: 20)
                            
                            Text("This product uses the TMDB API but is not endorsed or certified by TMDB.")
                                .foregroundColor(.secondary)
                                .font(.caption2)
                        }
                        .padding(.top, 50)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    PreferenceView()
}
