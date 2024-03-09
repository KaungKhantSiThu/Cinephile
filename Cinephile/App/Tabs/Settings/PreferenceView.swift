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
//                        NavigationLink(destination: Text("Destination View")) {
//                           ZStack {
//                               RoundedRectangle(cornerRadius: 10)
//                                   .fill(Color.gray)
//                                   .frame(height: 50)
//                                   .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
//                               
//                               HStack {
//                                   Spacer()
//                                   Text("Privacy Terms")
//                                       .foregroundColor(.white)
//                                       .font(.headline)
//                                   
//                                   Spacer()
//                                   
//                                   Image(systemName: "arrow.right.circle.fill")
//                                       .foregroundColor(.white)
//                                       .font(.system(size: 20))
//                               }
//                               .padding()
//                           }
//                        }
//                        .padding([.leading, .trailing], 50)
//
//                        NavigationLink(destination: AboutView()) {
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 10)
//                                    .fill(Color.gray)
//                                    .frame(height: 50)
//                                    .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
//                                
//                                HStack {
//                                    Spacer()
//                                    
//                                    Text("Acknowledgements")
//                                        .foregroundColor(.white)
//                                        .font(.headline)
//                                    
//                                    Spacer()
//                                    
//                                    Image(systemName: "arrow.right.circle.fill")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 20))
//                                }
//                                .padding()
//                            }
//                        }
//                        .padding([.leading, .trailing], 50)
                        
                        NavigationLink {
                            AboutView()
                        } label: {
                            Label("Acknowledgements", imageNamed: "arrow.right.circle.fill")
                        }
                        .buttonStyle(.borderedProminent)


                        VStack {
                            Text("Sequel is made possible by these data sources")
                                .foregroundColor(.secondary)
                                .font(.system(size: 13))
                            
                            Image("tmdb_logo")
                                .resizable()
                                .frame(width: 30, height: 20)
                            
                            Text("User ID: 12345678901")
                                .foregroundColor(.secondary)
                                .font(.system(size: 13))
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
