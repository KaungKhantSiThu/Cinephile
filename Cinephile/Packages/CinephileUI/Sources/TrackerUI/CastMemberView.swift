import SwiftUI
import TMDb

@MainActor
struct CastMemberView: View {
    var castMembers: [CastMember]
    var body: some View {
        VStack(alignment: .leading) {
            Text("Cast", bundle: .module)
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
    }
}
//
//#Preview {
//    CastMemberView(castMembers: .preview)
//}



