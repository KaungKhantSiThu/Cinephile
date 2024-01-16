//
//  File.swift
//  
//
//  Created by Kaung Khant Si Thu on 09/01/2024.
//

import SwiftUI

public struct PopularityBadge : View {
    public let score: Int
    public let textColor: Color
    
    @State private var isDisplayed = false
    
    public init(score: Int, textColor: Color = .primary) {
        self.score = score
        self.textColor = textColor
    }
    
    var scoreColor: Color {
        get {
            if score < 40 {
                return .red
            } else if score < 60 {
                return .orange
            } else if score < 75 {
                return .yellow
            }
            return .green
        }
    }
    
    var overlay: some View {
        ZStack {
            Circle()
                .trim(from: 0,
                      to: isDisplayed ? CGFloat(score) / 100 : 0)
                .stroke(style: StrokeStyle(lineWidth: 3))
                .foregroundColor(scoreColor)
                .animation(.interpolatingSpring(stiffness: 60, damping: 10).delay(0.1), value: score)
        }
        .rotationEffect(.degrees(-90))
        .onAppear {
            self.isDisplayed = true
        }
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.clear)
                .frame(width: 40)
                .overlay(overlay)
                .shadow(color: scoreColor, radius: 4)
            Text(score, format: .percent)
                .font(.system(size: 10))
                .fontWeight(.bold)
                .foregroundColor(textColor)
            }
            .frame(width: 40, height: 40)
    }
}

#if DEBUG
struct PopularityBadge_Previews : PreviewProvider {
    static var previews: some View {
        VStack {
            PopularityBadge(score: 80)
            PopularityBadge(score: 10)
            PopularityBadge(score: 30)
            PopularityBadge(score: 50)
        }
    }
}
#endif

