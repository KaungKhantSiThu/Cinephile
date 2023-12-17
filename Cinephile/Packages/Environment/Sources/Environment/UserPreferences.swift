//
//  File.swift
//  
//
//  Created by Kaung Khant Si Thu on 14/12/2023.
//

import Foundation
import Models
import Networking
import SwiftUI

@MainActor
@Observable public class UserPreferences {
    
    public static let sharedDefault = UserDefaults(suiteName: "group.com.kaungkhantsithu.CinephileApp")
    public static let shared = UserPreferences()

}
