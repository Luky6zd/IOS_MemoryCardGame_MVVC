//
//  MemoryGame.swift
//  MemoryCard
//
//  Created by Lucrezia Odrljin on 18.07.2024.

// Foundation modul za: Arrays, Bools, Ints, Dictionaries
import Foundation

// Model memory igre

// struktura generickog tipa CardContent, gdje se CardContent ponasa kao Equtable
struct MemoryGame<CardContent> where CardContent: Equatable {
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
            // dodavanje 2 kartice u array pomocu funkcije append sa argumentima id i content
            // uparivanje kartica: 1a 1b, 2a 2b, 3a 3b
            cards.append(Card(content: content, id: "\(pairIndex+1) a"))
            cards.append(Card(content: content, id: "\(pairIndex+1) b"))
        }
        
    }
    
    // "promjenjiva" funkcija chooseCard pomocu koje modificiramo index broj kartice
    // s internim argumentom card tipa Card, bez externog argumenta
    // funkcija odgovorna za igranje igre i mijesanje kartica
    mutating func chooseCard(_ card: Card) {
        // u chosenIndex se sprema sta vrati funkcija index-vraca broj indexa kartice
        let chosenIndex = index(of: card)
        // cards iz modela po odabranom indexu, okrece karticu faceUp-faceDown
        cards[chosenIndex].isFaceUp.toggle()
        //print("choose \(card)")
    }
    
    // funkcija za odabiranje kartice po indexu, vraca Int(broj indexa)
    func index(of card: Card) -> Int {
        // for petlja gdje kont.varijabla index izbroji kartice
        for index in cards.indices {
            // i ako je index id kartice jednak id-u kartice
            if cards[index].id == card.id {
                // vrati taj broj index
                return index
            }
        }
        return 0  // FIXME: func index
    }
    
    // funkcija za mijesanje kartica
    // mutating je kljucna rijec za funkciju koja modificira model
    mutating func shuffle() {
        cards.shuffle()
        print(cards)
    }
    
    // definiranje kartice u Modelu
    // ugnjezdena struktura (MemoryGame.Card)
    // Card se ponasa po protokolima Equatable, Identifiable
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        
        
        // globalna funkcija tako da u cijeloj app mozemo koristiti ==
        // argument left-hand-side je Card i right-hand-size je Card, vraca Bool da li su lijeva i desna strana kartice iste
        static func == (lhs: Card, rhs: Card) -> Bool {
            return lhs.isFaceUp == rhs.isFaceUp &&
            lhs.isMatched == rhs.isMatched &&
            lhs.content == rhs.content
        }
        
        // definiranje defaultnih vrijednosti kartice
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        // varijabla tipa CardContent(emoji na kartici)
        let content: CardContent
        // varijabla id tipa string
        var id: String
        // protokol za debug, za "ljepsi/cisci" ispis u konzoli
        var debugDescription: String {
            return "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "")"
        }
    }
}
