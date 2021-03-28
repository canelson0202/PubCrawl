//
//  PubCrawlWidget.swift
//  PubCrawlWidget
//
//  Created by Nelson, Connor on 3/15/21.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(for intent: PubSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(from: intent.pub, at: Date())
        completion(entry)
    }

    func getTimeline(for intent: PubSelectionIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let pubs = PubCrawlAPI.getPubList()

        guard let number = intent.pub?.number?.intValue else {
            let relevance = TimelineEntryRelevance(score: 0)
            let entry = SimpleEntry(relevance: relevance, date: Date(), name: "Pub", number: 0, resetDate: Date())
            completion(Timeline(entries: [entry], policy: .never))
            return
        }

        let pub = pubs[number]
        let lowRelevance = TimelineEntryRelevance(score: 0.1)
        var entries = [SimpleEntry(from: pub, at: Date(), with: lowRelevance)]

        if Date() < pub.resetDate {
            let highRelevance = TimelineEntryRelevance(score: 1.0)
            entries.append(SimpleEntry(from: pub, at: pub.resetDate, with: highRelevance))
        }

        completion(Timeline(entries: entries, policy: .never))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let name: String
    let number: Int
    let resetDate: Date
    let relevance: TimelineEntryRelevance?

    init(relevance: TimelineEntryRelevance? = nil, date: Date, name: String = "Pub", number: Int = 0, resetDate: Date = Date()) {
        self.date = date
        self.name = name
        self.number = number
        self.resetDate = resetDate
        self.relevance = relevance
    }

    init(from pub: Pub, at date: Date, with relevance: TimelineEntryRelevance? = nil) {
        self.init(relevance: relevance, date: date, name: pub.name, number: pub.number, resetDate: pub.resetDate)
    }

    init(from pub: IntentPub?, at date: Date, with relevance: TimelineEntryRelevance? = nil) {
        self.date = date
        self.name = pub?.displayString ?? "Pub"
        self.number = pub?.number?.intValue ?? 0
        self.relevance = relevance

        if let components = pub?.resetDate {
            self.resetDate = Calendar.current.date(from: components)!
        } else {
            self.resetDate = date
        }
    }
}

struct PubCrawlWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack(spacing: 0) {
            Image("pub\(entry.number)-outside")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 150)
                .clipped()

            if entry.date < entry.resetDate {
                Text("\(entry.name) opens in\n\(entry.resetDate, style: .relative)")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("\(entry.name) is open!")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color(red: 0, green: 99/255, blue: 28/255))
        .widgetURL(URL(string: "pubcrawl://pub?pubnumber=\(entry.number)"))
    }
}

@main
struct PubCrawlWidget: Widget {
    let kind: String = "PubCrawlWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: PubSelectionIntent.self, provider: Provider()) { entry in
            PubCrawlWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Pub Tracker")
        .description("Can we even get in here?")
        .supportedFamilies([.systemMedium])
    }
}

struct PubCrawlWidget_Previews: PreviewProvider {
    static let now = Date()
    static let entry1 = SimpleEntry(date: now, name: "The Bannered Mare", number: 0, resetDate: now)

    static let entry2 = SimpleEntry(
        date: now,
        name: "The Green Dragon Inn",
        number: 1,
        resetDate: Calendar.current.date(byAdding: .second, value: 10, to: now)!
    )
    static var previews: some View {
        Group {
            PubCrawlWidgetEntryView(entry: entry1)
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            PubCrawlWidgetEntryView(entry: entry2)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
