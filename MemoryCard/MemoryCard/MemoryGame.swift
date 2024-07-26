//
//  MemoryGame.swift
//  MemoryCard
//
//  Created by Lucrezia Odrljin on 18.07.2024.

// Foundation modul za: Arrays, Bools, Ints, Dictionaries
import Foundation

// Model memory igre

// struktura generickog tipa CardContent
struct MemoryGame<CardContent> {
    // varijabla cards tipa Array, tj.Array kartica u kojoj je samo pisanje/izmjena varijable privatno, citanje je javno
    // <CardContent> je generic
    private(set) var cards: Array<Card>
    
    // funkcija initializator, sadrzi informacije za kreiranje "same sebe", u ovom slucaju kartice
    // kreiran init sa argumentom numberOfCardPairs tipa Int i argument cardContentFactory funkcija koja prima Int i vraca CardContent
    init(numberOfCardPairs: Int, cardContentFactory: (Int) -> CardContent) {
        // init kartice da je tipa Array Kartica
        cards = Array<Card>() // || cards = []  // prazni array kartica
        
        // dodavanje 2 kartice pomocu for in petlje
        // pairIndex je kontrolna varijabla(brojac)
        // zastita da su na ekranu minimalno prikazane 2 kartice
        for pairIndex in 0..<max(2, numberOfCardPairs) {
            // varijabla content tipa cardContent i poziv funkcije cardContentFactory koja prima Int a vraca CardContent
            let content = cardContentFactory(pairIndex)
            // dodavanje 2 kartice u array pomocu funkcije append sa argumentom content
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
        
    }
    
    // funkcija chooseCard s internim argumentom card tipa Card, bez externog argumenta
    func chooseCard(_ card: Card) {
        
    }
    
    // funkcija za mijesanje kartica
    // mutating je kljucna rijec za funkciju koja modificira model
    mutating func shuffle() {
        cards.shuffle()
        print(cards)
    }
    
    // definiranje kartice u Modelu
    // ugnjezdena struktura (MemoryGame.Card)
    struct Card {
        // definiranje defaultnih vrijednosti kartice
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        // varijabla tipa CardContent(emoji na kartici)
        let content: CardContent
    }
}
