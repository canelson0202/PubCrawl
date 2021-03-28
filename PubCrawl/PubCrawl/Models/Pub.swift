//
//  Pub.swift
//  PubCrawl
//
//  Created by Nelson, Connor on 3/14/21.
//

import Foundation
import SwiftUI

struct Pub: Codable {
    let name: String
    let number: Int
    let currency: Money
    let drinkLimit: Int
    var currentDrinks: Int
    var resetDate: Date

    var outsideImage: Image {
        return Image("pub\(number)-outside")
    }

    var insideImage: Image {
        return Image("pub\(number)-inside")
    }

    var allowedIn: Bool {
        return currentDrinks < drinkLimit && Date() >= resetDate
    }

    init(name: String, number: Int, currency: Money, limit: Int) {
        self.init(name: name, number: number, currency: currency, drinkLimit: limit, currentDrinks: 0)
    }

    init(name: String, number: Int, currency: Money, drinkLimit: Int, currentDrinks: Int, resetDate: Date = Date()) {
        self.name = name
        self.number = number
        self.currency = currency
        self.drinkLimit = drinkLimit
        self.currentDrinks = currentDrinks
        self.resetDate = resetDate
    }
}
