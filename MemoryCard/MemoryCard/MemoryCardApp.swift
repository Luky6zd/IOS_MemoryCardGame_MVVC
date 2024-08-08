
//  MemoryCardApp.swift
//  MemoryCard
//
//  Created by Lucrezia Odrljin on 02.06.2024.


import SwiftUI

// oznaka za main program
@main
// struktura tipa App
struct MemoryCardApp: App {
    // omotac propertya gdje se instancira observable object
    @StateObject var game = EmojiMemoryGame()
    
    // computed property
    var body: some Scene {
        WindowGroup {
            // pozivanje komponente/funkcije koja prikazuje MemoryGame View
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
