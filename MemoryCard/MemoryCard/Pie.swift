//
//  Pie.swift
//  MemoryCard
//
//  Created by Luky on 01.08.2024.


import SwiftUI
// importanje radi koristenja sinusa, kosinusa, radiana
import CoreGraphics

// MARK: Pie Animation

// Pie struktura implementira Shape protokol
struct Pie: Shape {
    // pocetna tocka animacijskog kruga
    var startAngle: Angle = Angle.zero
    // zavrsna tocka animacijskog kruga
    let endAngle: Angle
    // smjer crtanja linije kruga
    let clockWise: Bool = true
    
    // funkcija path koja crta krug oko emojia i vraca path
    func path(in rect: CGRect) -> Path {
        // setiranje pocetne tocke kruga
        let startAngle = startAngle - .degrees(90)
        // setiranje zavrsne tocke kruga
        let endAngle = endAngle - .degrees(90)
        // middleX i middleY racunaju sredinu kruga
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // racunanje radiusa
        let radius = min(rect.width, rect.height) / 2
        // racunanje startne tocke
        let start = CGPoint(
            x: center.x + radius * cos(startAngle.radians),
            y: center.y + radius * sin(startAngle.radians)
        )
        
        // definiranje putanje animacijskog kruga
        var path = Path()
        // definiranje smjera kretanja
        path.move(to: center)
        // dodavanje linije
        path.addLine(to: start)
        // dodavanje oblika Arc (luka kruga)
        path.addArc(
            // setiranje argumenata
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: !clockWise
        )
        // povratak linije
        path.addLine(to: center)
        
        // vraca vrijednost putanje
        return path
    }
}


