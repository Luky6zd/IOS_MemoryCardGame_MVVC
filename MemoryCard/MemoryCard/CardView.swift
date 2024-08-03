//
//  CardView.swift
//  MemoryCard
//
//  Created by Luky on 31.07.2024.


import SwiftUI

// MARK: CardView

// struktura CardView tipa View koja prikazuje karticu
struct CardView: View {
    // alias za Card memory game
    typealias aCard = MemoryGame<String>.Card
    // kartica tipa MemoryGame String-a
    let card: aCard
    
    // inicijalizacija kartice
    init(_ card: aCard) {
        self.card = card
    }
    // definiranje konstantih vrijednosti View Modifiera
    private struct Constants {
        // prostor izmedu kartica(padding)
        static let inset: CGFloat = 5
        static let color: Color = .white
        
        // definiranje velicine fonta
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor = smallest / largest
        }
        // definiranje konstantnih vrijednosti za Pie animaciju
        struct Pie {
            static let opacity: CGFloat = 0.4
            static let inset: CGFloat = 10
        }
    }
    // funkcija body tipa some View
    var body: some View {
        // struktura Pie
        Pie(endAngle: .degrees(270))
            // View Modifieri
            .opacity(Constants.Pie.opacity)
            // preklapanje teksta na vrhu kruga
            .overlay(
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
                    // prostor izmedu emojia i ruba kruga
                    .padding(Constants.Pie.inset)
                    // rotacija emojia u krug kad su 2 kartice pogodene
                    .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                    // duzina trajanja animacije-rotacije definirana u ekstenziji
                    .animation(.spin(duration: 1), value: card.isMatched)
            )
            // prostor izmedu emojia i ruba kartice
            .padding(Constants.inset)
            // modificiranje sa Cardify modifierom
            .cardify(isFaceUp: card.isFaceUp)
            // View Modifier za modificiranje vidljivosti kartica
            // ako je kartica okrenuta faceUp ili je neodgovarajuca, vidljiva : prozirna kartica
            .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

// custom made dodatak Animaciji
// animation.spin
extension Animation {
    // definiranje spin funkcije sa agrumentom trajanja intervala spina
    static func spin(duration: TimeInterval) -> Animation {
        // vraca animaciju linearnog smjera i trajanja
        return linear(duration: 1.2).repeatForever(autoreverses: false)
    }
}

// struktura preview kartica
struct CardView_Previews: PreviewProvider {
    // alias za Card memory game
    typealias aCard = CardView.aCard
    // prikaz kartice u Previewu, ujedno i testiranje da li vizualno sve radi
    static var previews: some View {
        // Viewi upakirani u VStack za vertikalni prikaz
        VStack {
            // kreirana 2 previewa, po 1 za svaki HStack
            HStack {
                // prikaz kartice-testiranje
                CardView(aCard(isFaceUp: true, content: "x", id: "test"))
                    .aspectRatio(4/3, contentMode: .fit)
                CardView(aCard(content: "x", id: "test1"))
            }
            HStack {
                // prikaz kartice-testiranje
                CardView(aCard(isFaceUp: true, isMatched: true, content: "This is a very long string and I hope it fits", id: "test"))
                CardView(aCard(isMatched: true, content: "x", id: "test1"))
            }
        }
        // View Modifieri
        .foregroundStyle(.green)
        .padding()
    }
}


    
        
    

