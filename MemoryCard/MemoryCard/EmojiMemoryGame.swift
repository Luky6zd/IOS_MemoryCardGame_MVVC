//
//  EmojiMemoryGame.swift
//  MemoryCard
//
//  Created by Lucrezia Odrljin on 22.07.2024.


import SwiftUI

// MARK: View Model

// klasa jer ce EmojiMemoryGame biti share-ana/koristena u cijeloj memory igri
// implementiran protokol za prikaz promjena u UI-u
class EmojiMemoryGame: ObservableObject {
    // alias kartice
    typealias aCard =  MemoryGame<String>.Card
    // globalno dostupna privatna varijabla, ali setirana unutar klase
    private static let emoji = ["🏋🏻‍♀️", "⛹🏼‍♀️", "🏄🏾‍♀️", "🤽🏼", "🤾", "🚣🏼‍♀️", "🚵🏼‍♂️", "🤸🏽‍♂️", "🤼‍♀️", "🚴🏽‍♂️", "🏌🏿‍♂️", "⛷️"]
    
    // privatna globalno dostupna funkcija koja kreira memory game
    // vraca MemoryGame Stringa sa brojem kartica
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfCardPairs: 12) { pairIndex in
            // zastita ViewModela da broj kartica ne izade iz dosega
            // ako su emoji u range-u i imaju pairIndex
            if emoji.indices.contains(pairIndex) {
                // vrati emoji koji se nalazi na tom indexu
                return emoji[pairIndex]
                // ako je broj kartica izvan range-a
            } else {
                //  vrati emoji obavijest "!?"
                return "⁉️"
            }
        }
    }
    
    // privatna varijabla model tipa MemoryGame, koji je generic tipa String,
    // pohranjuje sto vrati funkcija createMemoryGame
    // markacija published oznacava da se na toj varijabli izvrsavaju promjene
    @Published private var model = createMemoryGame()
    
    // preko View Modela osiguravamo pristup varijabli card iz Modela
    // computed property, varijabla je tipa Array, MemoryGame koji je String
    // vraca Model kartica iz MemoryGame-a, da View "vidi" kartice
    var cards: Array<aCard> {
        return model.cards
    }
    
    // setiranje boje pozadine kartice preko View Modela
    var color: Color {
        return .mediumLille
    }
    
    // varijabla za izracun rezultata tipa int, computed property
    var score: Int {
        // vraca rezultat od modela(memory igre)
        return model.score
    }
    
    // MARK: - Intents
    // funkcija koja poziva shuffle funkciju u modelu
    func shuffle() {
        model.shuffle()
        // pozivanje funkcije koja vrsi promjene na UI/View-u
        objectWillChange.send()
    }
    
    // intent funkcija gdje user ima namjeru izabrati neku od ponudenih kartica
    // funkcija da View "vidi" funkciju chooseCard iz Modela koji je privatan
    func choose(_ card: aCard) {
        // model poziva metodu chooseCard sa argumentom card
        model.chooseCard(card)
    }
}

