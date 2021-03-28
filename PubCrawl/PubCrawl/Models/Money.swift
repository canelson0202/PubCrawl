//
//  Money.swift
//  PubCrawl
//
//  Created by Nelson, Connor on 3/14/21.
//

import Foundation
import SwiftUI

enum Money: String, Codable, Identifiable {
    case septim
    case gold
    case credit
    case galleon

    var id: String {
        return rawValue
    }

    var name: String {
        switch self {
        case .septim:
            return "Septim"
        case .gold:
            return "Gold"
        case .credit:
            return "Credit"
        case .galleon:
            return "Galleon"
        }
    }

    var image: Image {
        return Image(rawValue)
    }
}
