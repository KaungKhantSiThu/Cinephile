//
//  MovieRow.swift
//  TMDB Test
//
//  Created by Kaung Khant Si Thu on 27/10/2023.
//

import SwiftUI
import MediaClient


public struct MovieRow: View {
    let movie: Movie
    public var body: some View {
        HStack {
            
//            WebImage(url: URL(string: formatPosterPath(path: movie.posterPath!.absoluteString)))
//                .placeholder(Image(systemName: "photo"))
//                .resizable() // Resizable like SwiftUI.Image
//                 // Placeholder Image
//                .aspectRatio(contentMode: .fit)
//                .frame(height: 90)
                
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.genres?.map(\.name).joined(separator: ", ") ?? "No genre")
                    .font(.callout)
                
                Text(formattedRuntime(seconds: movie.runtime ?? 0))
                    .font(.footnote)
            }
            Spacer()
            Gauge(value: movie.voteAverage ?? 0.0, in: 0...10) {
               Text("Rating")
           } currentValueLabel: {
               Text(movie.voteAverage ?? 0.0, format: .number.precision(.fractionLength(1)))
                   .foregroundColor(formatColor(value: movie.voteAverage ?? 0.0))
           } minimumValueLabel: {
               Text("0").foregroundColor(.red)
           } maximumValueLabel: {
               Text("10").foregroundColor(.green)
           }
           
           .gaugeStyle(.accessoryCircular)
           .tint(formatColor(value: movie.voteAverage ?? 0.0))

        }
        .padding()
    }
    
    private func formattedRuntime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return String(format: "%d hr %02d min", hours, minutes)
    }
    
    private func formatPosterPath(path: String) -> String {
        return "https://image.tmdb.org/t/p/original" + path
    }
    
    private func formatColor(value: Double) -> Color {
        switch value {
        case 0.0...4.0: return .red
        case 4.1...6.5: return .yellow
        case 6.6...10.0: return .green
        default:
            return .white
        }
    }
}

//struct MovieRow_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieRow(movie: PreviewData.mockMovie)
//            .previewLayout(.sizeThatFits)
//
//    }
//}

public struct CountDownView: View {
    let releasedDate: Date
    public var body: some View {
        VStack {
            Text(remainingDays(from: releasedDate))
                .font(.title)
                .fontWeight(.semibold)
            
            if remainingDays(from: releasedDate) != "Out!" {
                Text("Days")
                    .font(.callout)
            }
        }
    }
    
    private func remainingDays(from date: Date) -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.day], from: currentDate, to: date)
        
        if let days = components.day, days > 0 {
            return "\(days)"
        } else {
            return "Out!"
        }
    }
}
