//
//  Cardify.swift
//  MemoryCard
//
//  Created by Luky on 01.08.2024.


import SwiftUI

// struktura implementira protokol ViewModifier, Animatable
struct Cardify: ViewModifier, Animatable {
    // inicijalizator
    init(isFaceUp: Bool) {
        // ako je kartica u rotaciji faceUp, rotacija je 0
        // inace je 180 stupnjeva
        rotation = isFaceUp ? 0 : 180
    }
    // varijabla isFaceUp tipa Bool
    var isFaceUp: Bool {
        // copmuted property cija je vrijednost rotacija manja od 90
        // sve dok je rotacija manja od 90 stupnjeva, faceUp se prikazuje, kada rotacija prijede 90 stupnjeva pozadina kartice se prikazuje
        rotation < 90
    }
    // varijabla rotacija tipa double
    var rotation: Double
    // varijabla Animatable protokola tipa double, computed property
    var animatableData: Double {
        // geter, vraca rotaciju
        get {
            return rotation
        }
        // setira rotaciju na novu vrijednost (newValue varijablu)
        set {
            rotation = newValue
        }
    }
    
    // definiranje konstantih vrijednosti View Modifiera
    private struct Constants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 2
    }
    
    // funkcija body koja vraca some View
    func body(content: Content) -> some View {
        ZStack {
            // lokalna varijabla tipa RoundedRectangle u ViewBuilderu
            // RoundedRectangle View sa argumentom cornerRadius vrijednosti 12
            // tijelo kartice faceUp
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            // tijelo kartice sa obrubom 2
            base.strokeBorder(lineWidth: Constants.lineWidth)
                // tijelo-pozadina lica kartice, bijele boje
                .background(base.fill(.white))
                // prekrivanje foregrounda sa contentom
                .overlay(content)
                // opacity View Modifier
                // ternary operator, ako je isFaceUp vidljiv : proziran
                .opacity(isFaceUp ? 1 : 0)
                // tijelo kartice-pozadina kartice
            base.fill()
                // modificiranje vidljivosti kartica sa opacity View Modifierom
                // ternary operator, ako je kartica okrenuta isFaceUp, prozirna : vidljiva kartica
                .opacity(isFaceUp ? 0 : 1)
        }
        // rotacija sa 3D efektom, ako je kartica faceUp okretanje je 0, ako je faceDown okretanje za 180 stupnjeva
        // isFaceUp ? 0 : 180
        // 0 na x osi, 1 na y osi, 0 na z osi
        .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
    }
}
 
// dodatak na View s kojim dodajemo novu funkciju
extension View {
    // kreiranje cardify funkcije, vraca some View
    func cardify(isFaceUp: Bool) -> some View {
        // tj.vraca Cardify modifier
        return modifier(Cardify(isFaceUp: isFaceUp))
    }
}

