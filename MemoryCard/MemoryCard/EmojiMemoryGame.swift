//
//  EmojiMemoryGame.swift
//  MemoryCard
//
//  Created by Lucrezia Odrljin on 22.07.2024.

// importanje SwiftUI-a jer je ViewModel dio UI
import SwiftUI

// View Model memory igre

// klasa jer ce EmojiMemoryGame biti share-ana/koristena u cijeloj memory igri
class EmojiMemoryGame {
    // globalno dostupna privatna varijabla, ali setirana unutar klase
    private static let emoji = ["🏋🏻‍♀️", "⛹🏼‍♀️", "🏄🏾‍♀️", "🤽🏼", "🤾", "🚣🏼‍♀️", "🚵🏼‍♂️", "🤸🏽‍♂️", "🤼‍♀️", "🚴🏽‍♂️", "🏌🏿‍♂️", "⛷️"]
    
    // privatna globalno dostupna funkcija koja kreira memory game, vraca MemoryGame Stringa
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfCardPairs: 4) { pairIndex in
            // zastita ViewModela da broj kartica ne izade iz dosega
            // ako su emoji u range-u i imaju pairIndex
            if emoji.indices.contains(pairIndex) {
                // vrati emoji koji se nalazi na tom indexu
                return emoji[pairIndex]
                // ako su izvan range-a, vrati obavijest
            } else {
                return "⁉️"
            }
        }
    }

    // privatna varijabla model tipa MemoryGame, koji je generic tipa String, pohranjuje sto vrati funkcija createMemoryGame
    private var model = createMemoryGame()
    
    // preko View Modela osiguravamo pristup varijabli card iz Modela
    // computed property, varijabla je tipa Array, MemoryGame koji je String
    // vraca Model kartica iz MemoryGame-a, da View "vidi" kartice
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // intent funkcija gdje user ima namjeru izabrati neku od ponudenih kartica
    // funkcija da View "vidi" funkciju chooseCard iz Modela koji je privatan
    func choose(_ card: MemoryGame<String>.Card) {
        // model poziva metodu chooseCard sa argumentom card
        model.chooseCard(card)
    }
}
