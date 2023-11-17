//
//  PostView.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 01/11/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostView: View {

    var body: some View {
        VStack(alignment: .leading) {
            ProfileWithTimeStamp()
            
            Text("Top Gun: Maverick is a thrilling sequel that surpasses the original. Tom Cruise delivers a stellar performance as the fearless and rebellious pilot who faces his demons and mentors a new generation of aviators. The action scenes are breathtaking and realistic, showcasing the best of modern fighter jets.")
                .font(.body)
            
            MovieRow(movie: PreviewData.mockMovie)
                .background(.thickMaterial)
                .clipShape(
                    RoundedRectangle(cornerRadius: 15)
                )
            
            HStack(spacing: 60) {
                
                Button {
                    print("Like")
                } label: {
                    HStack {
                        Image(systemName: "hand.thumbsup.fill")
                        Text("5")
                    }
                    
                }
                
                Button {
                    print("Like")
                } label: {
                    HStack {
                        Image(systemName: "text.bubble")
                        Text("12")
                    }
                }
                
                Button {
                    print("Like")
                } label: {
                    HStack {
                        Image(systemName: "arrow.2.squarepath")
                        Text("3")
                    }
                }
            }
            .padding(.top, 10)
            .tint(.red)
        }
        .padding()
    }

}

struct PostView_Preview: PreviewProvider {
    static var previews: some View {
        PostView()
            .previewLayout(.sizeThatFits)
    }
}

struct ProfileWithTimeStamp: View {
    var body: some View {
        HStack(alignment: .top) {
            WebImage(url: URL(string: "https://picsum.photos/seed/picsum/200"))
                .resizable() // Resizable like SwiftUI.Image
                .aspectRatio(contentMode: .fit)
                .frame(height: 50)
                .clipShape(
                    Circle()
                )
            
            VStack(alignment: .leading) {
                Text("Mg Kaung")
                    .font(.title3)
                    .foregroundStyle(.primary)
                Text("@mgkaung")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(Date(timeIntervalSinceNow: -36000).timeAgo)
        }
    }
}
