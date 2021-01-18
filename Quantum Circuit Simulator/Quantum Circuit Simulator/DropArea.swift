//
//  DropArea.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 11/01/2021.
//

import SwiftUI

struct DropArea: View {
    @Binding var dropSpots: [CGRect]
    
    var body: some View {
        GeometryReader {geo in
            
            Image(systemName: "plus.app.fill")
                .font(.system(size: 50))
                .background(Color.white)
                .onAppear(perform: {
                    let placeholderCoords = CGRect(x: geo.frame(in: .global).minX, y: geo.frame(in: .global).minY, width: 50, height: 50)
                    dropSpots.append(placeholderCoords)
                })
                .onDisappear(perform: {
                    dropSpots = []
                })
        }
    }
}
