import Foundation
import SwiftUI
import TMDb

struct CastMemberView: View {
    var castMembers: [CastMember]
    var body: some View {
        VStack(alignment: .leading) {
            Text("Cast")
                .font(.title)
                .fontWeight(.semibold)
                .padding([.leading, .bottom], 10)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(castMembers) { cast in
                        CastView(cast: cast)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    CastMemberView(castMembers: .preview)
}



