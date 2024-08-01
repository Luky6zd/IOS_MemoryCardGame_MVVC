//
//  AspectVGrid.swift
//  MemoryCard
//
//  Created by Lucrezia Odrljin on 30.07.2024.


import SwiftUI

// aspect ratio oriented vertical grid
// tipa generic, odgovara protokolu Identifiable
struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    // array items
    var items: [Item]
    // aspect ratio tipa floating point
    var aspectRatio: CGFloat = 1
    // ViewBuilder varijabla/funkcija sa argumentom Item koja vraca ItemView
    @ViewBuilder var content: (Item) -> ItemView
    
    // inicijalizacija aspectVgrida
    // items su tipa array Item, aspect ratio je tipa flaot, content je funkcija koja uzima Item i vraca ItemView
    init(_ items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        // items iz strukture = items iz inita
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        // container View/funkcija koja kreira sadrzaj kartice po custom parametrima za velicinu i prostor koji zauzimaju kartice
        GeometryReader { geometry in
            // poziv funkcije i spremanje u varijablu
            let gridItemSize = gridItemWidthThatFits(count: items.count, size: geometry.size, atAspectRatio: 2/3)
            // struct/View koji kartice prikazuje u obliku grida
            // kao argument definiramo broj stupaca kao array GridItem-a, te horizontalne i vertikalne razmake izmedu kartica
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                // ForEach petlja iterira kroz kartice i za svaku kreira novi View
                ForEach(items) { item in
                    // funkcija koja uzima item i vraca View
                    content(item)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }
    
    // funkcija za odredivanje velicine kartice
    // argumenti su broj kartica koje moraju fitat, velicina prostora, aspect ratio u koji karica mora fitat
    func gridItemWidthThatFits(count: Int, size: CGSize, atAspectRatio aspectRatio: CGFloat) -> CGFloat {
        // eksplicitna pretvorba iz inta u float
        let count = CGFloat(count)
        // broj stupaca
        var columnCount = 1.0
        // ponavlja se sve dok je broj stupaca manji od broja kartica
        repeat {
            // sirina kartice u stupcu
            let width = size.width / columnCount
            // visina kartice u stupcu
            let height = width / aspectRatio
            // izracun broja redova prema visini i sirini kartice
            let rowCount = (count / columnCount).rounded(.up)
            // ako je
            if (rowCount * height) < size.height {
                // vrati
                return (size.width / columnCount).rounded(.down)
            }
            // uvecaj broj stupaca za 1
            columnCount += 1
        // uvijet
        } while columnCount < count
        // vraca iskalkulirani broj/velicinu kartice koja "najbolje" odgovara
        return (size.width / columnCount).rounded(.down)
    }
}

//#Preview {
//   AspectVGrid()
//}
