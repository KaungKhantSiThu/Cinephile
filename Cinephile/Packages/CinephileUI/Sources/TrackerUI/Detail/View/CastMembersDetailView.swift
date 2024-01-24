//
//  CastMembersDetailView.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 25/11/2023.
//

import SwiftUI
import MediaClient


struct CastMembersDetailView: View {
    var castMembers: [CastMember]
    var body: some View {
        List(castMembers) { cast in
            CastView(castMember: cast)
        }
    }
}

//#Preview {
//    CastMembersDetailView(castMembers: .preview)
//}
