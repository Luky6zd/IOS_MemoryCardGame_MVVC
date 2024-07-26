
//  ContentView.swift
//  MemoryCard
//
//  Created by Lucrezia Odrljin on 02.06.2024.


import SwiftUI

// View memory igre

// struktura imena EmojiMemoryGameView tipa View
// prikazuje View na EmojiMemoryGame ViewModel
struct EmojiMemoryGameView: View {
    // varijabla tipa EmojiMemoryGame
    var viewModel: EmojiMemoryGame = EmojiMemoryGame()
    // array slicica tipa String
    let emoji: Array<String> = ["🏋🏻‍♀️", "⛹🏼‍♀️", "🏄🏾‍♀️", "🤽🏼", "🤾", "🚣🏼‍♀️", "🚵🏼‍♂️", "🤸🏽‍♂️", "🤼‍♀️", "🚴🏽‍♂️", "🏌🏿‍♂️", "⛷️"]
    // varijabla imena body tipa some View
    // body prikazuje vertikalni stack kartica
    // computed property(izracunava se svaki put ispocetka-pri koristenju) i vraca View
    var body: some View {
        // View u koji stavljamo kartice, kartice dobivaju scroll funkcionalnost
        ScrollView {
            // pozivanje komponente/funkcije
            cards
        }
        // funkcija View Modifier za umetanje prostora u VStacku
        .padding()
    }
    
    // varijabla/struktura tipa some View Layout koja prikazuje kartice
    var cards: some View {
        // struct/View koji kartice prikazuje u obliku grida
        // kao argument definiramo broj stupaca kao array GridItem-a
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85))]) {
            // ForEach petlja kreira 4 kartice(4 Viewa)
            // ViewBuilder sa argumentom index-kontrolna varijabla(counter)
            // varijabla indices vraca range od arraya, key path id: \.self
            ForEach(emoji.indices, id: \.self) { index in
                // pozivanje komponente/funkcije koja prikazuje karticu
                // preko indexa pristupamo vrijednosti u arrayu
                CardView(content: emoji[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
            // defaultna boja za HStack
            // funkcija View Modifier sa argumentom za setiranje boje
            .foregroundStyle(.tint)
        }
    }
}

// struktura CardView tipa View koja definira/setira karticu
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
            
            // View koji grupira skup elemenata u 1 grupu
            Group {
                // tijelo kartice-nalicje kartice
                base.foregroundStyle(.white) // ili .fill(.white)
                // tijelo kartice sa obrubom 12
                base.strokeBorder(lineWidth: 2)
                Text(content).font(Font.largeTitle) // Text View
            }
            // opacity View Modifier
            // ternary operator, ako je isFaceUp vidljiv : proziran
            .opacity(isFaceUp ? 1 : 0)
            // tijelo kartice-pozadina kartice
            base.fill()
                // modificiranje vidljivosti kartica sa opacity View Modifierom
                // ternary operator, ako je isFaceUp proziran : vidljiv
                .opacity(isFaceUp ? 0 : 1)
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
    EmojiMemoryGameView()
}
