//
//  CheckboxToggleStyle.swift
//  Cinephile
//
//  Created by Kaung Khant Si Thu on 08/03/2024.
//

import SwiftUI

struct CheckBoxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Button(action: { configuration.isOn.toggle() }){
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "checkmark.square")
                    .foregroundStyle(configuration.isOn ? Color.accentColor : .secondary)
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.large)
            }

            Spacer()
            
            configuration.label
        }
    }
}
