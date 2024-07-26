
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
    // markacija da je varijabla "promatrana" za promjene koje ce se izvrsiti
    @ObservedObject var viewModel: EmojiMemoryGame
    // array slicica tipa String
    let emoji: Array<String> = ["🏋🏻‍♀️", "⛹🏼‍♀️", "🏄🏾‍♀️", "🤽🏼", "🤾", "🚣🏼‍♀️", "🚵🏼‍♂️", "🤸🏽‍♂️", "🤼‍♀️", "🚴🏽‍♂️", "🏌🏿‍♂️", "⛷️"]
    // varijabla imena body tipa some View
    // body prikazuje vertikalni stack kartica
    // computed property(izracunava se svaki put ispocetka-pri koristenju) i vraca View
    var body: some View {
        VStack {
            // View u koji stavljamo kartice, kartice dobivaju scroll funkcionalnost
            ScrollView {
                // pozivanje komponente/funkcije
                cards
            }
            Button("Shuffle") {
                // View/Botun poziva viewModel da mijesa kartice
                viewModel.shuffle()
            }
        }
        // funkcija View Modifier za umetanje prostora u VStacku
        .padding()
    }
    
    // varijabla/struktura tipa some View Layout koja prikazuje kartice
    var cards: some View {
        // struct/View koji kartice prikazuje u obliku grida
        // kao argument definiramo broj stupaca kao array GridItem-a, te horizontalne i vertikalne razmake izmedu kartica
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
            // ForEach petljom iteriramo kroz kartice i kreiramo ih
            // ViewBuilder sa argumentom index-kontrolna varijabla(counter)
            // indices vraca range od arraya, key path id: \.self
            ForEach(viewModel.cards.indices, id: \.self) { index in
                // pozivanje komponente/funkcije koja prikazuje karticu
                // preko indexa pristupamo vrijednosti u arrayu
                CardView(viewModel.cards[index])
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
            }
            // defaultna boja za HStack
            // funkcija View Modifier sa argumentom za setiranje boje
            .foregroundStyle(.tint)
        }
    }
}

// struktura CardView tipa View koja prikazuje karticu
struct CardView: View {
    // kartica tipa MemoryGame String-a
    let card: MemoryGame<String>.Card
    
    // inicijalizacija kartice
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
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
                // Text View, sadrzaj kartice
                Text(card.content)
                    // velicina slicice
                    .font(.system(size: 200))
                    // smanjivanje velicine slicice na 1/100
                    .minimumScaleFactor(0.01)
                    // aspect ratio texta 1:1
                    .aspectRatio(1, contentMode: .fit)
            }
            // opacity View Modifier
            // ternary operator, ako je isFaceUp vidljiv : proziran
            .opacity(card.isFaceUp ? 1 : 0)
            // tijelo kartice-pozadina kartice
            base.fill()
                // modificiranje vidljivosti kartica sa opacity View Modifierom
                // ternary operator, ako je isFaceUp proziran : vidljiv
                .opacity(card.isFaceUp ? 0 : 1)
        }
    }
}

// struktura koja se prikazuje na canvasu(u Preview-u) kod ContentView-a
#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
