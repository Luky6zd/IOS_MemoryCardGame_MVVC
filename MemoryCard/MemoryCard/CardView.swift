//
//  CardView.swift
//  MemoryCard
//
//  Created by Luky on 31.07.2024.


import SwiftUI

// MARK: Card View

// struktura CardView tipa View koja prikazuje karticu
struct CardView: View {
    // alias za Card memory game
    typealias aCard = MemoryGame<String>.Card
    // kartica tipa alias MemoryGame-a
    let card: aCard
    
    // inicijalizacija kartice
    init(_ card: aCard) {
        self.card = card
    }
    
    // definiranje konstantih vrijednosti
    private struct Constants {
        // prostor izmedu kartica(padding)
        static let inset: CGFloat = 5
        static let color: Color = .white
        
        // substruct
        // velicina fonta
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor = smallest / largest
        }
        
        // substruct
        // konstantne vrijednosti za Pie animaciju
        struct Pie {
            static let opacity: CGFloat = 0.4
            static let inset: CGFloat = 5
        }
    }
    
    // funkcija body tipa some View
    var body: some View {
        // View za dodati timeline da se animacija odvrti
        TimelineView(.animation(minimumInterval: 1/10)) { timeline in
            // ako je kartica okrenuta faceUp ili je neodgovarajuca, prikazi Pie
            // Pie ce nestat iz UI ako je kartica matched i okrenuta faceDown
            if card.isFaceUp || !card.isMatched {
                // struktura Pie
                // opseg vrtnje animacije je preostali bonus puta 360 stupnjeva
                Pie(endAngle: .degrees(card.bonusPercentageRemaining * 360))
                    // View Modifieri
                    .opacity(Constants.Pie.opacity)
                    // preklapanje teksta na vrhu kruga
                    // prostor izmedu emojia i ruba kruga
                    .overlay(cardContents.padding(Constants.Pie.inset))
                    // prostor izmedu emojia i ruba kartice
                    .padding(Constants.inset)
                    // modificiranje sa Cardify modifierom
                    .cardify(isFaceUp: card.isFaceUp)
                    // animacija povlacenja kartica, kada su obe kartice pogodene
                    .transition(.scale)
            // ako nije
            } else {
                // prikazat ce prozirnu karticu, popunjava prostor-nema vise collapsa kartica u UI
                Color.clear
            }
        }
    }
    
    // sadrzaj kartice
    var cardContents: some View {
        // Text View-sadrzaj kartice (slicica emojia)
        Text(card.content)
            // najveca dopustena velicina emojia
            .font(.system(size: Constants.FontSize.largest))
            // najmanja dopustena velicina emojia
            .minimumScaleFactor(Constants.FontSize.scaleFactor)
            // viseredno centriranje teksta
            .multilineTextAlignment(.center)
            // aspect ratio texta 1:1
            .aspectRatio(1, contentMode: .fit)
            // rotacija emojia u krug kad su 2 kartice pogodene
            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
            // duzina trajanja animacije-rotacije definirana u ekstenziji
            .animation(.spin(duration: 1), value: card.isMatched)
    }
}

// dodatak Animaciji (animation.spin)
extension Animation {
    // definiranje spin funkcije sa agrumentom trajanja intervala spina
    static func spin(duration: TimeInterval) -> Animation {
        // vraca animaciju linearnog smjera i trajanja
        return linear(duration: 1).repeatForever(autoreverses: false)
    }
}

// preview testnih kartica na canvasu
struct CardView_Previews: PreviewProvider {
    // alias za Card memory game
    typealias aCard = CardView.aCard
    // prikaz kartice u Previewu, ujedno i testiranje da li vizualno sve radi
    static var previews: some View {
        // View-ovi upakirani u VStack za vertikalni prikaz
        VStack {
            // kreirana 2 previewa, po 1 za svaki HStack
            HStack {
                // prikaz kartica za testiranje izgleda i ponasanja
                CardView(aCard(isFaceUp: true, content: "x", id: "test"))
                    .aspectRatio(4/3, contentMode: .fit)
                CardView(aCard(content: "x", id: "test1"))
            }
            HStack {
                // prikaz kartica za testiranje izgleda i ponasanja
                CardView(aCard(isFaceUp: true, isMatched: true, content: "This is a very long string and I hope it fits", id: "test"))
                CardView(aCard(isMatched: true, content: "x", id: "test1"))
            }
        }
        // View Modifieri
        .foregroundStyle(.green)
        .padding()
    }
}


    
        
    

