//
//  Date+Formatter.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 30/11/2023.
//

import Foundation

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
}
