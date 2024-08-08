
//  ContentView.swift
//  MemoryCard
//
//  Created by Lucrezia Odrljin on 02.06.2024.


import SwiftUI

// MARK: View

// struktura imena EmojiMemoryGameView tipa View
// prikazuje View memory igre
struct EmojiMemoryGameView: View {
    // kreiranje aliasa
    typealias Card = MemoryGame<String>.Card
    // varijabla tipa EmojiMemoryGame
    // markacija da je varijabla "promatrana" za promjene koje ce se izvrsiti
    @ObservedObject var viewModel: EmojiMemoryGame
    
    // kreiranje konstanti
    private let aspectRatio: CGFloat = 2/3
    // razmak izmedu podjeljenih kartica
    private let spacing: CGFloat = 4
    // delay izmedu podjele pojedine kartice (0.15 sec)
    private let dealInterval: TimeInterval = 0.15
    // brzina animacije podjele svake kartice (0.5 sec)
    private let dealAnimation: Animation = .easeInOut(duration: 0.5)
    // velicina kartica (decka)
    private let deckWidth: CGFloat = 60
    
    // varijabla body tipa some View
    // computed property(izracunava se svaki put ispocetka-pri koristenju) i vraca View
    var body: some View {
        // Vertical Stack View, View Builder
        VStack(alignment: .center) {
            // Horizontal Stack View
            HStack {
                // pozivanje/umetanje komponente
                goblet
                // umetanje praznog prostora izmedu pehara i naslova
                Spacer()
                // pozivanje/umetanje komponente
                gameTitle
                // umetanje praznog prostora od ruba naslova do ruba Viewa
                Spacer()
            }
            // Divider()
            // Vertical Stack View
            VStack {
                // pozivanje komponente/funkcije i setiranje boje preko View Modela
                cards.foregroundStyle(viewModel.color)
                // ViewModifier za dodavanje animacije karticama kad pritisnemo shuffle
                //.animation(.default, value: viewModel.cards)
            }
            // horizontalni stack View
            HStack {
                // pozivanje/umetanje komponente
                score
                // umetanje praznog prostora izmedu scorea i shufflea
                Spacer()
                // umetanje deka kartica i setiranje boje
                cardDeck.foregroundStyle(viewModel.color)
                Spacer()
                // pozivanje/umetanje komponente
                shuffle
            }
        }
        // umetanje prostora u VStacku, oko vanjskog ruba kartica
        .padding()
        // boja pozadine
        .background(Color("LightBrown"))
    }
    
    // kreiranje i prikaz pehara
    private var goblet: some View {
        // naslov igre
        Text("🏆")
            // View Modifieri
            // velicina
            .font(.system(size: 50))
            //.frame(width: 100, height: 100, alignment: .center)
    }
    
    // kreiranje i prikaz naslova
    private var gameTitle: some View {
        Text("Memory game")
            // View Modifieri
            .font(.system(size: 30))
            .foregroundStyle(.darkLille)
            .fontWeight(.heavy)
            .frame(width: 250, height: 70, alignment: .center)
            .background(.powder)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // prikaz rezultata
    private var score: some View {
        // Text View za prikaz rezultata
        Text("Score: \(viewModel.score)")
            // View Modifieri za score
            .font(.system(size: 24))
            .fontWeight(.heavy)
            .foregroundStyle(.darkLille)
            // override-a eksplicitnu animaciju-fadeInOut, ponistava animaciju za score View
            .animation(nil)
    }
    
    // kreiranje i prikaz shuffle botuna
    private var shuffle: some View {
        // botun za mijesanje kartica
        Button("Shuffle") {
            // poziv funkcije za mijesanje kartica sa animacijom
            withAnimation {
                // View/Botun poziva viewModel da izmijesa kartice
                viewModel.shuffle()
            }
        }
        // View Modifieri za shuffle botun
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
    
    // varijabla/struktura tipa some View Layout koja prikazuje kartice
    private var cards: some View {
        // aspect vertical grid sa argumentima
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            // ako je kartica podijeljena, prikazi ju na ekranu
            if isCardDealt(card) {
                // pozivanje komponente/funkcije koja prikazuje karticu
                CardView(card)
                    // ViewModifieri
                    .padding(spacing)
                    // geometrijsko racunanje animacije da animacija kartica stane unutar ekrana
                    .matchedGeometryEffect(id: card.id, in: dealingCardsNameSpace)
                    // identity je tranzicija bez modifikacija animacije, defaultni prikaz
                    // asimetricna tranzicija, koja je identity za insert i remove View animacije
                    // ne override-a Matched Geometry
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    // prekrivanje kartice
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    // definira prioritet pojavljivanja na ekranu
                    .zIndex(scoreChange(causedBy: card) != 0 ? 1 : 0)
                    // na dodir kartice, biranje kartice preko Viewmodela
                    .onTapGesture {
                        // poziv funkcije
                        choose(card)
                    }
                    // animacija ucitavanja kartica na pocetnom zaslonu
                    //.transition(.offset(
                    //    x: CGFloat.random(in: -500...500),
                    //    y: CGFloat.random(in: -500...500)
                    //))
            }
        }
    }
    
    // setiranje podjele karata tipa set, set id-ova kartica, defaultne vrijednosti prazno
    // ako je card id u setu, kartica je podijeljena
    @State private var dealingCards = Set<Card.ID>()
    
    // funkcija za provjeru da li je kartica podijeljena, vraca bool
    private func isCardDealt(_ card: Card) -> Bool {
        // vraca id kartica koje su podijeljene
        return dealingCards.contains(card.id)
    }
    
    // setiranje nepodjeljenih kartica tipa array kartica
    private var undealtCards: [Card] {
        // vraca filtrirane kartice koje nisu podijeljene
        // $0 je prvi parametar funkcije
        return viewModel.cards.filter { !isCardDealt($0) }
    }
    
    // kreiranje Namespace-a
    // omatanje i smjestanje varijable u taj namespace
    @Namespace private var dealingCardsNameSpace
    
    // deck kartica
    private var cardDeck: some View {
        // najgornji View u hijerarhiji prikazuje deck
        // prikazuje ZStack nepodjeljenih kartica
        ZStack {
            // petljom prolazimo kroz deck nepodjeljenih karata, card je iterator
            ForEach(undealtCards) { card in
                // u card viewu ispisujemo sve kartice
                CardView(card)
                    // iste animacije su primjenjene za card i deck
                    // za prikaz animacije podjele kartice koristimo izracunate vrijednosti unutar ekrana
                    // id sluzi za identificiranje Card Viewa i kartice unutar Viewa, a s in definiramo u kojem namespace-u vrsimo podjelu kartica
                    .matchedGeometryEffect(id: card.id, in: dealingCardsNameSpace)
                    // tranzicija animacije
                    // identity je tranzicija bez modifikacija animacije, defaultni prikaz
                    // asimetricna tranzicija, koja je identity za insert i remove View animacije
                    // ne override-a Matched Geometry
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        // definiranje velicine decka
        // frame modifier ce s navedenim parametrima izraditi mali container za smjestit nepodjeljene kartice
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        // na dodir kartica u decku vrsi se podjela kartica
        .onTapGesture {
            // poziv funkcije za podjelu kartica
            deal()
        }
    }
    
    // funkcija za podjelu kartica iz decka
    private func deal() {
        // pocetna vrijednost time delaya
        var delay: TimeInterval = 0
        // for petlja sa kontrolnom varijablom card prolazi kroz kartice
        for card in viewModel.cards {
            // i na kartice primjenjuje delay pri dijeljenju
            withAnimation(dealAnimation.delay(delay)) {
                // i inserta kartice po id-u
                // _ = je znak za rijesiti se upozorenja da se .withAnimation nigdje ne koristi
                _ = dealingCards.insert(card.id)
            }
            // nakon ispisa svake kartice na ekranu delay je 0.15 sec
            delay += dealInterval
        }
    }
    
    // funkcija za animaciju kartice
    private func choose(_ card: Card) {
        // dodavanje animacije karticama
        withAnimation {
            // lokalna varijabla u koju se sprema rezultat prije izbora kartice
            let scoreBeforeChoosing = viewModel.score
            // izbor kartice sa animacijom
            // promjena vrijednosti varijable pri svakom klikanju kartice
            viewModel.choose(card)
            // u varijablu se spremna izracun trenutnog rezultata igre minus rezultat prije klikanja kartice
            let scoreChange = viewModel.score - scoreBeforeChoosing
            // update varijable, sprema se izmjena rezultata i koja je to kartica(po njenom id-u)
            // dodjeljivanje vrijednosti tuple tipu varijable
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    // setiranje varijable tipa tuple sa 2 argumenta
    // Card.ID je generic-u nasem slucaju string
    @State private var lastScoreChange: (amount: Int, causedByCardId: Card.ID) = (amount: 0, causedByCardId: "")
    
    // funkcija za promjenu rezultata, vraca int
    // racunat ce promjenu rezultata od zadnje odabrane kartice
    private func scoreChange(causedBy card: Card) -> Int {
        // iscitavanje/koristenje podataka pohranjenih u 2 tuple varijable i pohranjivanje u last score change koja je takoder tuple tip varijable
        let (amount, causedByCardId: id) = lastScoreChange
        // vrati da je id kartice score changed jednak id-u kartice sa last score change-om, s tolikom kolicinom, inace nema promjene u rezultatu
        return card.id == id ? amount : 0
    }
}

// struktura koja se prikazuje na canvasu(u Preview-u) kod ContentView-a
#Preview {
    // prikaz Memory igre preko viewModela
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
