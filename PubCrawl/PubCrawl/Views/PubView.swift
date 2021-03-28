//
//  PubView.swift
//  PubCrawl
//
//  Created by Nelson, Connor on 3/14/21.
//

import SwiftUI
import WidgetKit

struct PubView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var pubList: [Pub]
    let pubIndex: Int
    @Binding var pubTab: [Money: Int]

    @State var buttonEnabled: Bool
    @State var emitterPos: CGFloat = 2

    var currency: Money {
        pubList[pubIndex].currency
    }

    // https://github.com/ArthurGuibert/SwiftUI-Particles
    var emitter: ParticlesEmitter {
        get {
            let base = EmitterCell()
                .content(.image(UIImage(named: "particle")!))
                .lifetime(10)
                .birthRate(10)
                .scale(0.25)
                .scaleRange(0.05)
                .spin(4)
                .spinRange(10)
                .velocity(-700)
                .velocityRange(20)
                .yAcceleration(350)
                .emissionLongitude(.pi)
                .emissionRange(.pi / 4)

            return ParticlesEmitter {
                base
            }
        }
    }

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            Color.green
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }, label: {
                        Text("Done")
                            .bold()
                            .padding(5)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10.0)
                    })
                }

                Text(pubList[pubIndex].name)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                Spacer(minLength: 16)

                pubList[pubIndex].insideImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 400)
                    .clipped()
                    .border(Color.white, width: 5)

                Spacer(minLength: 16)

                Button(action: {
                    print("drink tapped")
                    drink()
                }) {
                    ZStack {
                        Color.orange

                        Text("🍺🍺🍺🍺🍺🍺🍺")
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)

                        if (!buttonEnabled) {
                            Color.black
                                .opacity(0.7)
                        }
                    }
                    .frame(maxWidth: 360, maxHeight: 100)
                    .border(Color.white, width: 5)
                }
                .disabled(!buttonEnabled)

                Spacer()
            }

            emitter
                .emitterSize(CGSize(width: 20, height: 20))
                .emitterShape(.line)
                .emitterPosition(CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * emitterPos))
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       maxHeight: 1,
                       alignment: .center)

        }
    }

    private func drink() {
        buttonEnabled = false
        animateDrink()
        updatePubTab()

        pubList[pubIndex].currentDrinks += 1

        // Check if we've hit our limit
        if pubList[pubIndex].currentDrinks >= pubList[pubIndex].drinkLimit {
            updatePubResetTime()

            // TODO: reload the pub tracker widget
            WidgetCenter.shared.getCurrentConfigurations { result in
                guard case .success(let widgets) = result else { return }

                if let widget = widgets.first(where: { widget in
                    let intent = widget.configuration as? PubSelectionIntent
                    return intent?.pub?.number?.intValue == pubIndex
                }) {
                    WidgetCenter.shared.reloadTimelines(ofKind: widget.kind)
                }
            }

        } else {
            PubCrawlAPI.savePubList(pubList: pubList)
            buttonEnabled = true
        }
    }

    private func animateDrink() {
        emitterPos = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            emitterPos = 2
        }
    }

    private func updatePubTab() {
        // Add to our current tab
        let currentCount = pubTab[currency] ?? 0
        pubTab[currency] = currentCount + 1

        // Save the updated pub tab
        PubCrawlAPI.savePubTab(pubTab: pubTab)
    }

    private func updatePubResetTime() {
        // Set up the pub to reset in 15 seconds
        pubList[pubIndex].currentDrinks = 0
        pubList[pubIndex].resetDate = Date().addingTimeInterval(15)

        // Save the list of houses
        PubCrawlAPI.savePubList(pubList: pubList)
    }
}

struct HouseView_Previews: PreviewProvider {
    static let pubList = [Pub(name: "The Bannered Mare", number: 0, currency: .septim, limit: 10)]
    static var previews: some View {
        PubView(pubList: .constant(pubList), pubIndex: 0, pubTab: .constant([.septim: 1]), buttonEnabled: true)
    }
}

