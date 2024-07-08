
//  ContentView.swift
//  MemoryCard
//
//  Created by Lucrezia Odrljin on 02.06.2024.


import SwiftUI

// struktura imena ContentView tipa View
struct ContentView: View {
    // varijabla imena body tipa some View
    // computed property(izracunava se svaki put ispocetka-pri koristenju)
    var body: some View {
        // View (grupira View-e u horizontalnu grupu side-to-side, slaze ih u stack)
        HStack {
            // pozivanje komponente/funkcije koja prikazuje karticu
            CardView(isFaceUp: true)
            CardView()
            CardView()
        }
        // defaultna boja za HStack
        .foregroundStyle(.tint) // funkcija View Modifier sa argumentom
        .padding() // funkcija View Modifier
    }
}

// struktura CardView tipa View koja predstavlja karticu
struct CardView: View {
    // varijabla tipa Bool
    var isFaceUp: Bool = false
    
    var body: some View {
        // View (grupira View-e u grupu od vrha prema dnu, slaze ih u stack)
        ZStack {
            // ako je isFaceUp true
            if isFaceUp {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.white)
                // RoundedRedtangle View sa argumentom cornerRadius vrijednosti 12
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(lineWidth: 2)
                Text("🏋🏻‍♀️").font(.largeTitle) // Text View
            // ako je isFaceUp false
            } else {
                RoundedRectangle(cornerRadius: 12)
            }
        }
    }
}



// struktura koja se prikazuje na canvasu(u Preview-u) kod ContentView-a
#Preview {
    ContentView()
}
