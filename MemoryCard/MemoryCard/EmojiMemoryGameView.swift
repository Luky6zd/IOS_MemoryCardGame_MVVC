
//  ContentView.swift
//  MemoryCard
//
//  Created by Lucrezia Odrljin on 02.06.2024.


import SwiftUI

// MARK: View memory igre

// struktura imena EmojiMemoryGameView tipa View
// prikazuje View na EmojiMemoryGame ViewModel
struct EmojiMemoryGameView: View {
    // varijabla tipa EmojiMemoryGame
    // markacija da je varijabla "promatrana" za promjene koje ce se izvrsiti
    @ObservedObject var viewModel: EmojiMemoryGame
    // varijabla aspect ratio tipa float
    private let aspectRatio: CGFloat = 2/3
    // varijabla imena body tipa some View
    // body prikazuje vertikalni stack kartica
    // computed property(izracunava se svaki put ispocetka-pri koristenju) i vraca View
    var body: some View {
        // vertikalni stack View
        VStack(alignment: .center) {
            // horizontalni stack
            HStack {
                // naslov igre
                Text("🏆")
                // View Modifieri
                    .font(.system(size: 50))
                    .frame(width: 100, height: 100, alignment: .center)
                Spacer()
                Text("Memory game")
                // View Modifieri
                    .font(.system(size: 30))
                    .foregroundStyle(Color("DarkLille"))
                    .fontWeight(.heavy)
                    .frame(width: 250, height: 70, alignment: .center)
                    .background(Color("Powder"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
            //Divider()
            // View u koji stavljamo kartice, kartice dobivaju scroll funkcionalnost
            ScrollView {
                // pozivanje komponente/funkcije
                cards
                // ViewModifier za dodavanje animacije
                    .animation(.default, value: viewModel.cards)
            }
            // horizontalni stack View
            HStack {
                // botun za mijesanje kartica
                Button("Shuffle") {
                    // View/Botun poziva viewModel da izmijesa kartice
                    viewModel.shuffle()
                }
                // View Modifieri
                .foregroundStyle(.white)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.buttonBorder)
                .font(.system(size: 20))
                .padding(0)
                .frame(width: 100, height: 50, alignment: .bottom)
                .cornerRadius(10)
                .fontWeight(.semibold)
                .tint(Color("DarkLille"))
            }
        }
        // umetanje prostora u VStacku
        .padding()
        // boja pozadine
        .background(Color("LightBrown"))
    }

    // varijabla/struktura tipa some View Layout koja prikazuje kartice
    private var cards: some View {
        // aspect vertical grid sa argumentima 
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            // pozivanje komponente/funkcije koja prikazuje karticu
            CardView(card)
            // ViewModifieri
                .padding(4)
            // biranje kartice preko Viewmodela
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
        // funkcija View Modifier sa argumentom za setiranje boje pozadine kartice
        .foregroundStyle(Color("MediumLille"))
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
            // tijelo kartice faceUp
            let base = RoundedRectangle(cornerRadius: 10)
            
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
                // ternary operator, ako je kartica okrenuta isFaceUp, prozirna : vidljiva kartica
                .opacity(card.isFaceUp ? 0 : 1)
        }
        // View Modifier za modificiranje vidljivosti
        // ako je kartica okrenuta faceUp ili je neodgovarajuca, vidljiva : prozirna kartica
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

// struktura koja se prikazuje na canvasu(u Preview-u) kod ContentView-a
#Preview {
    // prikaz viewModela
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
