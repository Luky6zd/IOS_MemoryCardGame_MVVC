
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
    // konstanta-varijabla aspect ratio tipa float
    private let aspectRatio: CGFloat = 2/3
    // konstanta-varijabla spacing tipa float
    private let spacing: CGFloat = 4
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
            VStack {
                    // pozivanje komponente/funkcije
                    cards
                        // funkcija View Modifier sa argumentom za setiranje boje pozadine kartice preko View Modela
                        .foregroundStyle(viewModel.color)
                        // ViewModifier za dodavanje animacije karticama ka pritisnemo shuffle
                        //.animation(.default, value: viewModel.cards)
            }
            // horizontalni stack View
            HStack {
                // botun za mijesanje kartica
                Button("Shuffle") {
                    // poziv funkcije za mijesanje kartica sa animacijom
                    withAnimation {
                        // View/Botun poziva viewModel da izmijesa kartice
                        viewModel.shuffle()
                    }
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
        // umetanje prostora u VStacku, oko vanjskog ruba kartica
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
                .padding(spacing)
            // biranje kartice preko Viewmodela
                .onTapGesture {
                    // dodavanje animacije
                    withAnimation(.easeInOut(duration: 2)) {
                        // izbor kartice sa animacijom
                        viewModel.choose(card)
                    }
                }
        }
    }
}


// struktura koja se prikazuje na canvasu(u Preview-u) kod ContentView-a
#Preview {
    // prikaz viewModela
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
