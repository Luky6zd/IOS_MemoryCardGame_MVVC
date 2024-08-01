//
//  MemoryGame.swift
//  MemoryCard
//
//  Created by Lucrezia Odrljin on 18.07.2024.


// Foundation modul za: Arrays, Bools, Ints, Dictionaries
import Foundation

// MARK: Model memory igre

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
    // kartica koja je jedina okrenuta faceUp tipa optional Int, pocetne vrijednosti not set,
    // jer na pocetku igre nemamo index kartice, sve kartice su po defaultu okrenute faceDown
    // get+set computed property, izracunavat ce svaki put novu vrijednost indexa faceUp kartice
    var indexOfOneAndOnlyFaceUpCard: Int? {
        // dobavljanje vrijednosti indexa kartice
        get {
            // array varijaba svih indexa faceUp kartica tipa int
            // po defautu prazan array, kroz igru sprema okrenute kartice
            var faceUpCardIndices = [Int]()
            // for petlja prolazi kroz kartice i trazi ima li medu karticama odabrana faceUp kartica
            for index in cards.indices {
                // ako je kartica okrenuta faceUp
                if cards[index].isFaceUp {
                    // dodajemo ju na kraj arraya
                    faceUpCardIndices.append(index)
                }
            }
            // ako je jedna okrenuta kartica faceUp
            if faceUpCardIndices.count == 1 {
                // vrati tu karticu i spremi ju na prvo mjesto u arrayu
                return faceUpCardIndices.first
            // ako nije
            } else {
                // vrati
                return nil
            }
        }
        // setiranje indexa jedne okrenute faceUp kartice
        set {
            // for petlja prolazi kroz sve kartice i trazi ima li medu njima kartica sa novom vrijednosti indexa
            for index in cards.indices {
                // ako index kartice ima novu vrijednost
                if index == newValue {
                    // nova kartica po indexu je faceUp
                    cards[index].isFaceUp = true
                // ako nema
                } else {
                    // nova kartica po indexu je faceDown
                    cards[index].isFaceUp = false
                }
            }
        }
    }
    // MARK: GAME LOGIC
    // "promjenjiva" funkcija chooseCard pomocu koje modificiramo index broj kartice
    // s internim argumentom card tipa Card, bez externog argumenta
    // funkcija odgovorna za igranje igre i mijesanje kartica
    mutating func chooseCard(_ card: Card) {
        // u chosenIndex se sprema sta vrati funkcija index-vraca broj indexa kartice
        // ako je chosenIndex Int, id kartice je validan
        if let chosenIndex = index(of: card) {
            // ulazimo u egzekuciju okretanja kartice
            // ako izabrana kartica na indexu nije faceUp i ako nije ista kao izabrana kartica
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                // ako index potencijalno odabrane kartice odgovara indexu okrenute kartice
                if let potencialMatchIndex = indexOfOneAndOnlyFaceUpCard {
                    // ako sadrzaj emoji-a odabrane kartice je isti kao sadrzaj emoji-a potencijalno okrenute kartice
                    if cards[chosenIndex].content == cards[potencialMatchIndex].content {
                        // tada je index kartice odgovarajuci
                        cards[chosenIndex].isMatched = true
                        // sto znaci da je i kartica odgovarajuca
                        cards[potencialMatchIndex].isMatched = true
                    }
                // ako nema odgovarajuci match izmedu kartica
                } else {
                    // postavljanje vrijednosti okrenute kartice na izabranu karticu
                    indexOfOneAndOnlyFaceUpCard = chosenIndex
                }
                // izabrana/kliknuta kartica po indexu, uvijek ce biti okrenuta faceUp(bez obzira da li je missmatched ili je faceDown)
                cards[chosenIndex].isFaceUp = true
            }
        }
    }
    
    // funkcija za odabiranje kartice po indexu, vraca optional Int(broj indexa)
    private func index(of card: Card) -> Int? {
        // for petlja gdje kont.varijabla index izbroji kartice
        for index in cards.indices {
            // i ako je index id kartice jednak id-u kartice
            if cards[index].id == card.id {
                // vrati taj broj index
                return index
            }
        }
        // vrati optional nil u slucaju da kartica pod odredenim indexom ne postoji
        return nil
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
        // globalna funkcija tako da u cijeloj app mozemo koristiti ==
        // argument left-hand-side je Card i right-hand-size je Card, vraca Bool da li su lijeva i desna strana kartice iste
        static func == (lhs: Card, rhs: Card) -> Bool {
            return lhs.isFaceUp == rhs.isFaceUp &&
            lhs.isMatched == rhs.isMatched &&
            lhs.content == rhs.content
        }
    }
}
