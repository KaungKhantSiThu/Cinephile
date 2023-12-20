//
//  SwiftUI_Preview+Extension.swift
//
//
//  Created by Kaung Khant Si Thu on 19/12/2023.
//

import SwiftUI

extension Binding {
    static func mock(_ value: Value) -> Self {
        var value = value
        return Binding(get: { value }, set: { value = $0 })
    }
}
