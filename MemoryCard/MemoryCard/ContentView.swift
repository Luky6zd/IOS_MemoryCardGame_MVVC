
//  ContentView.swift
//  MemoryCard
//
//  Created by Lucrezia Odrljin on 02.06.2024.


import SwiftUI

// struktura imena ContentView tipa View
struct ContentView: View {
    // array slicica tipa String
    let emoji: Array<String> = ["🏋🏻‍♀️", "⛹🏼‍♀️", "🏄🏾‍♀️", "🤽🏼", "🤾"]
    // varijabla imena body tipa some View
    // computed property(izracunava se svaki put ispocetka-pri koristenju)
    var body: some View {
        // View (grupira View-e u horizontalnu grupu side-to-side, slaze ih u stack)
        HStack {
            // ForEach petlja kreira 4 kartice(4 Viewa)
            // ViewBuilder sa argumentom index-kontrolna varijabla(counter)
            // varijabla indices vraca range od arraya, key path id: \.self
            ForEach(emoji.indices, id: \.self) { index in
                // pozivanje komponente/funkcije koja prikazuje karticu
                // preko indexa pristupamo vrijednosti u arrayu
                CardView(content: emoji[index])
            }
        }
        // defaultna boja za HStack
        .foregroundStyle(.tint) // funkcija View Modifier sa argumentom
        .padding() // funkcija View Modifier
    }
}

// struktura CardView tipa View koja predstavlja karticu
struct CardView: View {
    let content: String
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
                Text(content).font(.largeTitle) // Text View
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
