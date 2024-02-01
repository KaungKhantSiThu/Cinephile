import SwiftUI
import MediaClient

@MainActor
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
                        CastView(castMember: cast)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding([.leading, .trailing], 20)
    }
}
//
//#Preview {
//    CastMemberView(castMembers: .preview)
//}



