//
//  IntentHandler.swift
//  PubCrawlIntent
//
//  Created by Nelson, Connor on 3/15/21.
//

import Intents

class IntentHandler: INExtension, PubSelectionIntentHandling {
    func providePubOptionsCollection(for intent: PubSelectionIntent, with completion: @escaping (INObjectCollection<IntentPub>?, Error?) -> Void) {
        let pubs = PubCrawlAPI.getPubList()

        let intentPubs = pubs.map { pub -> IntentPub in
            let intentPub = IntentPub(identifier: "\(pub.number)", display: pub.name)
            intentPub.number = NSNumber(value: pub.number)
            intentPub.resetDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: pub.resetDate)
            return intentPub
        }

        completion(INObjectCollection(items: intentPubs), nil)
    }

    func defaultPub(for intent: PubSelectionIntent) -> IntentPub? {
        let pub = PubCrawlAPI.getDefaultPub()

        let intentPub = IntentPub(identifier: "\(pub.number)", display: pub.name)
        intentPub.number = NSNumber(value: pub.number)
        intentPub.resetDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: pub.resetDate)

        return intentPub
    }

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
}
