import Foundation
import SwiftUI
import TMDb

struct CastMemberView: View {
    var castMembers: [CastMember]
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello World")
                .font(.title2)
                .fontWeight(.semibold)
                .padding([.leading, .bottom], 10)
            ForEach(castMembers) { cast in
                HStack(spacing: 20) {
                    Image(systemName: "person")
                        .background(in: Circle().inset(by: -8))
                        .backgroundStyle(.red.gradient)
                        .foregroundStyle(.white.shadow(.drop(radius: 1, y: 1.5)))
                    VStack(alignment: .leading) {
                        Text(cast.name)
                        Text(cast.character)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.leading, 20)
                
                Divider()
            }
        }
    }
}

#Preview {
    CastMemberView(castMembers: .preview)
        .onAppear {
            print(CastMember.preview)
        }
}

