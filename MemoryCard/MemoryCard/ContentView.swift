
//  ContentView.swift
//  MemoryCard
//
//  Created by Lucrezia Odrljin on 02.06.2024.


import SwiftUI

// struktura imena ContentView tipa View
struct ContentView: View {
    // array slicica tipa String
    let emoji: Array<String> = ["🏋🏻‍♀️", "⛹🏼‍♀️", "🏄🏾‍♀️", "🤽🏼", "🤾", "🚣🏼‍♀️", "🚵🏼‍♂️", "🤸🏽‍♂️", "🤼‍♀️", "🚴🏽‍♂️", "🏌🏿‍♂️", "⛷️"]
    // varijabla tipa int sa defaultnim brojem kartica
    @State var cardCount: Int = 4
    // varijabla imena body tipa some View
    // body prikazuje vertikalni stack kartica
    // computed property(izracunava se svaki put ispocetka-pri koristenju) i vraca View
    var body: some View {
        // VStack View (grupira View-e u vertikalnu grupu)
        VStack {
            ScrollView {
                // pozivanje komponente/funkcije
                cards
            }
            // View za umetanje praznog prostora izmedu kartica i botuna
            Spacer()
            // pozivanje ikona/botuna add/remove
            cardCountModifiers
        }
        // funkcija View Modifier za umetanje prostora u VStacku
        .padding()
    }
    
    // kreiranje funkcija za modificiranje kartica, vraca some View
    // 1.argument "by offset" ima 2 imena, 1.koristimo pri pozivanju funkcije, a 2.u kreiranju funkcije
    func cardCountModifier(by offset: Int, symbol: String) -> some View {
        // kreiranje botuna za dodavanje nove kartice, sa argumentom action
        Button(action: {
                // uvecavanje za broj offset koji definiramo pri pozivu funkcije
                cardCount = cardCount + offset
        // ViewBuilder label koji modificira View botuna
        }, label: {
            // ikonica add
            Image(systemName: symbol)
            //Text("Add")
        })
        // View Modifier za onesposobljavanje add i remove botuna sa uvijetima
        // uvjet 1: remove ne moze ici ispod vrijednosti 1 ili
        // uvjet 2: add ne moze ici preko vrijednosti definiranog broja kartica
        .disabled(cardCount + offset < 1 || cardCount + offset > emoji.count  )
    }
    
    // pozivanje funkcije za dodavanje kartice i spremanje u varijablu sto funkcija vrati
    var cardAdder: some View {
        cardCountModifier(by: +1, symbol: "rectangle.stack.fill.badge.plus")
    }
    
    // pozivanje funkcije za brisanje kartice i spremanje u varijablu sto funkcija vrati
    var cardRemover: some View {
        cardCountModifier(by: -1, symbol: "rectangle.stack.fill.badge.minus")
    }
    
    var cardCountModifiers: some View {
        // HStack View (grupira View-e u horizontalnu grupu side-to-side, slaze ih u stack)
        HStack {
            // pozivanje komponente/funcije
            cardRemover
            // View za umetanje praznog prostora izmedu elemenata, gurne ih do kraja po horizontalnoj liniji
            Spacer()
            // pozivanje komponente/funcije
            cardAdder
        }
        // ViewModifieri za povecavanje ikonica za cijeli HStack
        .imageScale(.large)
        .font(.largeTitle)
    }
    
    // varijabla/struktura tipa some View Layout koja prikazuje kartice
    var cards: some View {
        // struct/View koji kartice prikazuje u obliku grida
        // kao argument definiramo broj stupaca kao array GridItem-a
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
            // ForEach petlja kreira 4 kartice(4 Viewa)
            // ViewBuilder sa argumentom index-kontrolna varijabla(counter)
            // varijabla indices vraca range od arraya, key path id: \.self
            ForEach(0..<cardCount, id: \.self) { index in
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
                Text(content).font(.largeTitle) // Text View
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
    ContentView()
}
