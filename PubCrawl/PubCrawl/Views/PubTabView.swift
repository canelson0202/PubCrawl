//
//  PubTabView.swift
//  PubCrawl
//
//  Created by Nelson, Connor on 3/14/21.
//

import SwiftUI

struct PubTabView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var pubTab: [Money: Int]

    var keys: [Money] {
        return pubTab.keys
            .map { $0 }
            .sorted { c1, c2 in
                pubTab[c1] ?? 0 >= pubTab[c2] ?? 0
            }
    }

    var body: some View {
        ZStack {
            Image("coins-background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity(0.4)

            VStack {
                HStack {
                    Spacer(minLength: 340)
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }, label: {
                        Text("Done")
                            .bold()
                            .padding(5)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10.0)
                    })
                    Spacer()
                }

                Text("Pub Tab")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 16) {
                        ForEach(keys) { key in
                            HStack(spacing: 0) {
                                key.image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: 100)
                                    .clipped()

                                Text("\(self.pubTab[key] ?? 0)")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.black)
                                    .frame(width: 100, height: 100)
                            }
                            .background(Color.orange)
                            .frame(minHeight: 75, idealHeight: 100)
                            .border(Color.white, width: 5)
                        }
                    }
                    .padding(32)
                }
            }
        }
    }
}

struct CandyBag_Previews: PreviewProvider {
    static var previews: some View {
        PubTabView(pubTab: .constant([
            .septim: 12,
            .gold: 32,
            .credit: 125,
            .galleon: 1204
        ]))
    }
}

