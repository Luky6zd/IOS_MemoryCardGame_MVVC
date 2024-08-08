//
//  MemoryGame.swift
//  MemoryCard
//
//  Created by Lucrezia Odrljin on 18.07.2024.


// Foundation modul za: Arrays, Bools, Ints, Dictionaries
import Foundation

// MARK: Model

// struktura generickog tipa CardContent, CardContent implementira Equtable protokol
struct MemoryGame<CardContent> where CardContent: Equatable {
    // varijabla cards tipa Array, tj.Array kartica u kojoj je samo pisanje/izmjena varijable privatno, citanje je javno
    // <CardContent> je tip generic
    private(set) var cards: Array<Card>
    // setiranje varijable score tipa int na defaultnu vrijdnost 0
    private(set) var score: Int = 0
    
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
            let content: CardContent = cardContentFactory(pairIndex)
            // dodavanje 2 kartice u array pomocu funkcije append sa argumentima id i content
            // uparivanje kartica: 1a 1b, 2a 2b, 3a 3b
            cards.append(Card(content: content, id: "\(pairIndex+1) a"))
            cards.append(Card(content: content, id: "\(pairIndex+1) b"))
        }
    }
    
    // kartica koja je jedina okrenuta faceUp tipa optional Int
    // jer na pocetku igre nemamo index kartice, sve kartice su po defaultu okrenute faceDown
    // get+set computed property, izracunavat ce svaki put novu vrijednost indexa faceUp kartice
    var indexOfOneAndOnlyFaceUpCard: Int? {
        // dobavljanje vrijednosti indexa kartice
        get {
            // array varijaba svih indexa faceUp kartica tipa int
            // po defaultu prazan array, kroz igru sprema okrenute kartice
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
                if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard {
                    // ako sadrzaj emoji-a odabrane kartice je isti kao sadrzaj emoji-a potencijalno okrenute kartice
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        // tada je index kartice odgovarajuci
                        cards[chosenIndex].isMatched = true
                        // sto znaci da je i kartica odgovarajuca
                        cards[potentialMatchIndex].isMatched = true
                        // uvecaj score varijablu za 2, dodaj joj bonus bodove(ako ih ima)
                        score += 2 + cards[chosenIndex].bonus + cards[potentialMatchIndex].bonus
                    // ako se kliknute kartice ne podudaraju
                    } else {
                        // ako su kartice na definiranom indexu okrenute, videne i ne podudaraju se
                        if cards[chosenIndex].hasBeenSeen {
                            // kazna, umanjivanje scora za -1
                            score -= 1
                        }
                        // ako su kartice na definiranom indexu okrenute, videne i ne podudaraju se
                        if cards[potentialMatchIndex].hasBeenSeen {
                            // kazna, umanjivanje scora za -1
                            score -= 1
                        }
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
        // for petlja gdje kontrolna varijabla index izbroji kartice
        for index in cards.indices {
            // i ako je index id kartice jednak id-u kartice
            if cards[index].id == card.id {
                // vrati taj broj indexa
                return index
            }
        }
        // vrati optional nil u slucaju da kartica pod odredenim indexom ne postoji
        return nil
    }
    
    // funkcija za mijesanje kartica
    // mutating je kljucna rijec za funkciju koja modificira model
    mutating func shuffle() {
        //  pozivanje funkcije za mijesanje karata
        cards.shuffle()
        //print(cards)
    }
    
    // definiranje kartice u Modelu
    // ugnjezdena struktura (MemoryGame.Card)
    // Card implementira protokole Equatable, Identifiable
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        // definiranje defaultnih vrijednosti kartice
        var isFaceUp: Bool = false {
            // property observer
            // kada se isFaceUp dogodi
            didSet {
                // ako je faceUp true, startat ce bonus vrijeme za okretanje 2.kartice
                if isFaceUp {
                    // poziv funkcije
                    startUsingBonusTime()
                // drugacije, prestaje teci bonus vrijeme
                } else {
                    stopUsingBonusTime()
                }
                // ako su stara vrijednost kartice(faceUp) i nova vrijednost kartice(faceDown) true
                if oldValue && !isFaceUp {
                    // kartica je "videna"
                    hasBeenSeen = true
                }
            }
        }
        
        // varijabla da li je kartica videna
        var hasBeenSeen: Bool = false
        // varijabla da li je kartica odgovarajuca
        var isMatched: Bool = false {
            didSet {
                // ako su kartice matchane, prestaje teci bonus vrijeme
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        
        // varijabla tipa CardContent(emoji na kartici)
        let content: CardContent
        // varijabla id tipa string 
        var id: String
        // protokol za debug, za "ljepsi/cisci" ispis u konzoli
        var debugDescription: String {
            // vraca vrijednosti id-a, contenta, da li je kartica okrenuta faceUp ili faceDown
            return "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "")"
        }
        
        // globalna funkcija tako da u cijeloj app mozemo koristiti usporedivanje vrijednosti
        // argument left-hand-side je Card i right-hand-size je Card, vraca Bool da li su lijeva i desna strana kartice iste
        // funkcija provjerava da li je lijeva strana kartice jednaka desnoj strani kartice
        static func == (lhs: Card, rhs: Card) -> Bool {
            return lhs.isFaceUp == rhs.isFaceUp &&
            lhs.isMatched == rhs.isMatched &&
            lhs.content == rhs.content
        }
        
        // MARK: Bonus Time in game scoring
        
        // varijabla tipa datum, optional
        // zadnji trenutak kada je kartica bila okrenuta faceUp
        var lastFaceUpDate: Date?
        
        // varijabla tipa TimeInterval vrijednosti 6, ako je vrijednost 0 to znaci da nema bonusa za brzo okretanje kartice
        var bonusTimeLimit: TimeInterval = 6
        
        // ukupno vrijeme koje je kartica bila okrenuta faceUp
        var pastFaceUpTime: TimeInterval = 0
        
        // varijabla tipa TimeInterval, computed property
        // racuna koliko je vremena proslo otkada je odabrana kartica okrenuta faceUp i neuparena
        var faceUpTime: TimeInterval {
            // ako je zadnji trenutak otkad je kartica okrenuta faceUp
            if let lastFaceUpDate {
                // vrati zbroj pastFaceupTime-a i vremena od lastFaceUpDate-a
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            // ako nije
            } else {
                // vrati koliko je proslo vremena otkad je kartica okrenuta faceUp
                return pastFaceUpTime
            }
        }
        
        // setiranje postotka preostalog bonus vremena, vraca izracun
        // racuna koliko je vremana potroseno za odabir 2.kartice
        var bonusPercentageRemaining: Double {
            // koliko vremena je kartica okrenuta faceUp podijeljeno sa preostalim vremenom
            return bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime) / bonusTimeLimit : 0
        }
        
        // setiranje bonusa za rezultat
        // bonus koji je dosada sakupljen- na principu 1 poen za svaku sekundu od time limita koja nije upotrebljena, bonus se smanjuje sto je kartica duze okrenuta faceUp bez da je match-ana sa drugom karticom
        var bonus: Int {
            // 6 sekundi puta postotak preostalog vremena
            // npr. 6 sekundi je 100% vremena i donosi 6 poena, 3 sekunde je 50% vremena i donosi 3 poena
            Int(bonusTimeLimit * bonusPercentageRemaining)
        }
        
        // funkcija za pracenje bonus vremena/bodova
        // koristi se svaki put kad se kartica okrene faceUp, prati koliko je dugo vremena kartica bila okrenuta faceUp
        private mutating func startUsingBonusTime() {
            // ako je kartica okrenuta faceUp i nije uparena i preostali bonus je veci od 0,
            // zadnji trenutak faceUp kartice je none
            if isFaceUp && !isMatched && bonusPercentageRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // funkcija se koristi svaki put kad se kartica vrati na faceDown
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
}

// dodatak arrayu
extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
