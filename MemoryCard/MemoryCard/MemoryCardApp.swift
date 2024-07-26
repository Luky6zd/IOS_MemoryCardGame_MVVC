
//  MemoryCardApp.swift
//  MemoryCard
//
//  Created by Lucrezia Odrljin on 02.06.2024.


import SwiftUI


//main program
@main
// struktura tipa App
struct MemoryCardApp: App {
    // computed property
    var body: some Scene {
        WindowGroup {
            // pozivanje komponente/funkcije koja prikazuje ContentView
            EmojiMemoryGameView()
        }
    }
}
