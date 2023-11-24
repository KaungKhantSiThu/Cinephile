import SwiftUI
import TMDb
import SDWebImageSwiftUI

struct MovieCoverView: View {
    let movie: Movie
    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: URL(string: formatPosterPath(path: movie.posterPath?.absoluteString ?? "")))
                .placeholder(Image(systemName: "photo"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 120)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
                
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .fontWeight(.semibold)
                    .frame(width: 80)
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundStyle(.primary)
                    
                Text(formatReleasedDate(date: movie.releaseDate))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

        }
        .padding()
        
    }
    
    private func formatPosterPath(path: String) -> String {
        return "https://image.tmdb.org/t/p/original" + path
    }
    
    private func formatReleasedDate(date: Date?) -> String {
        let dateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter
        }()
        
        if let date = date {
            return dateFormatter.string(from: date)
        } else {
            return "No Date"
        }
    }
}

struct MovieCoverView_Previews: PreviewProvider {
    static var previews: some View {
        MovieCoverView(movie: Movie.preview!)
            .previewLayout(.sizeThatFits)
    }
}
