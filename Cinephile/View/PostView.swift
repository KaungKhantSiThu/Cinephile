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
                
                Text(timeAgoString(from: Date(timeIntervalSinceNow: -36000)))
            }
            
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
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
    
    func timeAgoString(from date: Date) -> String {
        let secondsAgo = Int(Date().timeIntervalSince(date))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour

        if secondsAgo < minute {
            return "\(secondsAgo) s"
        } else if secondsAgo < hour {
            let minutes = secondsAgo / minute
            return "\(minutes) m"
        } else if secondsAgo < day {
            let hours = secondsAgo / hour
            return "\(hours) h"
        } else {
            let days = secondsAgo / day
            return "\(days) days ago"
        }
    }

}

struct PostView_Preview: PreviewProvider {
    static var previews: some View {
        PostView()
            .previewLayout(.sizeThatFits)
    }
}
