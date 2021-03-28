//
//  PubCrawlAPI.swift
//  PubCrawl
//
//  Created by Nelson, Connor on 3/14/21.
//

import Foundation

struct PubCrawlAPI {
    private static var baseCacheDir: URL? {
        // TODO: - replace group ID
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.pubcrawl")
    }

    private static var pubTabDir: URL? {
        return baseCacheDir?.appendingPathComponent("pubTab")
    }

    private static var pubListDir: URL? {
        return baseCacheDir?.appendingPathComponent("pubList")
    }

    static func savePubTab(pubTab: [Money: Int]) {
        guard let url = pubTabDir else {
            print("unable to find the pub tab url")
            return
        }

        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(pubTab) else {
            print("unable to encode pub tab")
            return
        }

        do {
            try data.write(to: url, options: [Data.WritingOptions.atomic])
            print("pub tab saved")
        } catch let error {
            print(error)
        }
    }

    static func savePubList(pubList: [Pub]) {
        guard let url = pubListDir else {
            print("unable to find the pub list url")
            return
        }

        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(pubList) else {
            print("unable to encode pub list")
            return
        }

        do {
            try data.write(to: url, options: [Data.WritingOptions.atomic])
            print("pub list saved")
        } catch let error {
            print(error)
        }
    }

    static func getPubTab() -> [Money: Int] {
        guard let url = pubTabDir else {
            print("unable to find the pub tab url")
            return createPubTab()
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let pubTab = try decoder.decode([Money: Int].self, from: data)
            print("pub tab retrieved")
            return pubTab
        } catch let error {
            print(error)
            return createPubTab()
        }
    }

    static func getPubList() -> [Pub] {
        guard let url = pubListDir else {
            print("unable to find the pub list url")
            return createPubList()
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let pubList = try decoder.decode([Pub].self, from: data)
            print("pub list retrieved")
            return pubList
        } catch let error {
            print(error)
            return createPubList()
        }
    }

    static func getDefaultPub() -> Pub {
        let pubList = getPubList()
        guard !pubList.isEmpty else {
            return Pub(name: "The Bannered Mare", number: 0, currency: .septim, limit: 10)
        }
        return pubList[0]
    }

    private static func createPubList() -> [Pub] {
        return [
            Pub(name: "The Bannered Mare", number: 0, currency: .septim, limit: 10),
            Pub(name: "The Green Dragon Inn", number: 1, currency: .gold, limit: 9),
            Pub(name: "Mos Eisley Cantina", number: 2, currency: .credit, limit: 8),
            Pub(name: "The Leaky Cauldron", number: 3, currency: .galleon, limit: 7)
        ]
    }

    private static func createPubTab() -> [Money: Int] {
        return [
            .septim: 0,
            .gold: 0,
            .credit: 0,
            .galleon: 0
        ]
    }
}

