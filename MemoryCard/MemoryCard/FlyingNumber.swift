//
//  FlyingNumber.swift
//  MemoryCard
//
//  Created by Luky on 03.08.2024.


import SwiftUI

// MARK: Animation Number

// struktura, implementira View protokol
struct FlyingNumber: View {
    // varijabla number tipa int
    let number: Int
    // varijabla offset tipa float
    @State private var offset: CGFloat = 0
    
    // varijabla tipa some View
    var body: some View {
        // ako je broj razlicit od 0, ispisi vrijednost broja
        if number != 0 {
            // tekst sa formatiranim prikazom broja, +2 se uvijek prikazuje
            Text(number, format: .number.sign(strategy: .always()))
                // View Modifieri
                .font(.title)
                .foregroundStyle(number < 0 ? .red : .green)
                .shadow(color: .black, radius: 1.5, x: 1, y: 1)
                .fontWeight(.semibold)
                // definira relativnu vrijednost offseta
                .offset(x: 0, y: offset)
                // vidljivost +2 broja, kada broj nije 0
                .opacity(offset != 0 ? 0 : 1)
                // kad se View ucita
                .onAppear() {
                    // radi animaciju
                    withAnimation(.easeOut(duration: 1.3)) {
                        // pocetak animacije od 0 prema gore (na x osi)
                        offset = number < 0 ? 150 : -150
                    }
                }
                // kad se View ne prikazuje
                .onDisappear {
                    // resetiranje offseta na 0
                    offset = 0
                }
        }
    }
}

#Preview {
    // preview na canvasu
    FlyingNumber(number: 4)
}
