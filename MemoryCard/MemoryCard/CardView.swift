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
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 2
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
        // View (grupira View-e u grupu od vrha prema dnu, slaze ih u stack)
        ZStack {
            // lokalna varijabla tipa RoundedRectangle u ViewBuilderu
            // RoundedRectangle View sa argumentom cornerRadius vrijednosti 12
            // tijelo kartice faceUp
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            
            // View koji grupira skup elemenata u 1 grupu
            Group {
                // tijelo kartice-nalicje kartice
                base.foregroundStyle(Constants.color) // ili .fill(.white)
                // tijelo kartice sa obrubom 12
                base.strokeBorder(lineWidth: Constants.lineWidth)
                // setiranje kruga oko emojia
                Pie(endAngle: .degrees(270))
                    .opacity(Constants.Pie.opacity)
                    // preklapanje teksta na vrhu kruga
                    .overlay(
                        // Text View, sadrzaj kartice
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
                        )
                        // prostor izmedu emojia i ruba kartice
                        .padding(Constants.inset)
            }
            // opacity View Modifier
            // ternary operator, ako je isFaceUp vidljiv : proziran
            .opacity(card.isFaceUp ? 1 : 0)
            // tijelo kartice-pozadina kartice
            base.fill()
                // modificiranje vidljivosti kartica sa opacity View Modifierom
                // ternary operator, ako je kartica okrenuta isFaceUp, prozirna : vidljiva kartica
                .opacity(card.isFaceUp ? 0 : 1)
        }
        // View Modifier za modificiranje vidljivosti
        // ako je kartica okrenuta faceUp ili je neodgovarajuca, vidljiva : prozirna kartica
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
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


    
        
    

