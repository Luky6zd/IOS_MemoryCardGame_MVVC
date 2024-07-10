
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
            CardView(isFaceUp: true)
            CardView(isFaceUp: true)
        }
        // defaultna boja za HStack
        .foregroundStyle(.tint) // funkcija View Modifier sa argumentom
        .padding() // funkcija View Modifier
    }
}

// struktura CardView tipa View koja predstavlja karticu
struct CardView: View {
    // varijabla tipa Bool defaultne vrijednosti true
    // @State omotac koristimo kada privremeno zelimo promijeniti stanje varijable,
    // u ovom slucaju koristimo ga za okretanje kartice
    @State var isFaceUp: Bool = true
    
    var body: some View {
        // View (grupira View-e u grupu od vrha prema dnu, slaze ih u stack)
        ZStack {
            // lokalna varijabla tipa RoundedRectangle u ViewBuilderu
            // RoundedRectangle View sa argumentom cornerRadius vrijednosti 12
            let base = RoundedRectangle(cornerRadius: 12)
            // ako je isFaceUp true
            if isFaceUp {
                // bit ce aktivna bijela strana kartice
                base.foregroundStyle(.white) // ili .fill(.white)
                // tijelo kartice sa obrubom 12
                base.strokeBorder(lineWidth: 2)
                Text("🏋🏻‍♀️").font(.largeTitle) // Text View
            // ako je isFaceUp false
            } else {
                base.fill()
            }
        }
        // funkcija onTapGesture
        .onTapGesture {
            // toogle funkcija za okretanje kartice(true/false)
            isFaceUp.toggle()
            // ispis u konzoli
            print("tapped")
        }
    }
}



// struktura koja se prikazuje na canvasu(u Preview-u) kod ContentView-a
#Preview {
    ContentView()
}
