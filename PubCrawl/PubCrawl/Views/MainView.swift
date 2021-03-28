//
//  ContentView.swift
//  PubCrawl
//
//  Created by Nelson, Connor on 3/14/21.
//

import SwiftUI

struct MainView: View {
    @State var pubList: [Pub] = PubCrawlAPI.getPubList()
    @State var pubTab: [Money: Int] = PubCrawlAPI.getPubTab()

    @State var showingPub0: Bool = false
    @State var showingPub1: Bool = false
    @State var showingPub2: Bool = false
    @State var showingPub3: Bool = false
    @State var showingTab: Bool = false

    var body: some View {
        ZStack {
            Image("festive-background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8)

            VStack(alignment: .center, spacing: 16) {
                Spacer()

                Button(action: {
                    print("pub tab tapped")
                    self.showingTab.toggle()
                }) {
                    Text("Pub Tab")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: 360, maxHeight: 100)
                        .border(Color.white, width: 5)
                        .background(Color.orange)
                }
                .sheet(isPresented: $showingTab, onDismiss: { showingTab = false }) {
                    PubTabView(pubTab: $pubTab)
                }

                Spacer()

                HStack {
                    Button(action: {
                        print("pub 0 tapped")
                        self.showingPub0 = true
                    }) {
                        createTextButton(with: "\(pubList[0].name)")
                    }
                    .sheet(isPresented: $showingPub0, onDismiss: { showingPub0 = false }) {
                        PubView(pubList: $pubList, pubIndex: 0, pubTab: $pubTab, buttonEnabled: pubList[0].allowedIn)
                    }

                    Button(action: {
                        print("pub 1 tapped")
                        self.showingPub1 = true
                    }) {
                        createTextButton(with: "\(pubList[1].name)")
                    }
                    .sheet(isPresented: $showingPub1, onDismiss: { showingPub1 = false }) {
                        PubView(pubList: $pubList, pubIndex: 1, pubTab: $pubTab, buttonEnabled: pubList[1].allowedIn)
                    }
                }

                HStack {
                    Button(action: {
                        print("pub 2 tapped")
                        self.showingPub2 = true
                    }) {
                        createTextButton(with: "\(pubList[2].name)")
                    }
                    .sheet(isPresented: $showingPub2, onDismiss: { showingPub2 = false }) {
                        PubView(pubList: $pubList, pubIndex: 2, pubTab: $pubTab, buttonEnabled: pubList[2].allowedIn)
                    }

                    Button(action: {
                        print("pub 3 tapped")
                        self.showingPub3 = true
                    }) {
                        createTextButton(with: "\(pubList[3].name)")
                    }
                    .sheet(isPresented: $showingPub3, onDismiss: { showingPub3 = false }) {
                        PubView(pubList: $pubList, pubIndex: 3, pubTab: $pubTab, buttonEnabled: pubList[3].allowedIn)
                    }
                }

                Spacer()
            }
        }
        .onOpenURL { url in
            showingPub0 = false
            showingPub1 = false
            showingPub2 = false
            showingPub3 = false
            showingTab = false

            if let host = url.host, host.lowercased().contains("tab") {
                showingTab = true
            } else if let host = url.host, host.lowercased().contains("pub") {
                let pubNumber = URLComponents(url: url, resolvingAgainstBaseURL: true)?
                    .queryItems?
                    .first(where: { $0.name.lowercased() == "pubnumber" })

                guard let id = pubNumber?.value else { return }

                switch id {
                case "0": showingPub0 = true
                case "1": showingPub1 = true
                case "2": showingPub2 = true
                case "3": showingPub3 = true
                default: break
                }
            }
        }
    }

    private func createTextButton(with text: String) -> some View {
        return Text(text)
            .font(.title)
            .bold()
            .multilineTextAlignment(.center)
            .foregroundColor(.black)
            .frame(maxWidth: 175, maxHeight: 175)
            .border(Color.white, width: 5)
            .background(Color.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

