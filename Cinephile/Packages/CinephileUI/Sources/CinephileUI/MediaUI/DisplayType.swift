//
//  DisplayType.swift
//
//
//  Created by Kaung Khant Si Thu on 29/01/2024.
//

import SwiftUI
import Models

enum DisplayType {
    case image
    case av
    
    init(from attachmentType: MediaAttachment.SupportedType) {
        switch attachmentType {
        case .image:
            self = .image
        case .video, .gifv, .audio:
            self = .av
        }
    }
}
