//
//  DropArea.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 11/01/2021.
//

import SwiftUI

struct DropArea: View {
    @State var qNum: Int
    @Binding var dropSpots: [Int: [CGRect]]
    
    var body: some View {
        GeometryReader {geo in
            
            Image(systemName: "plus.app.fill")
                .font(.system(size: 60))
                .background(Color("primary"))
                .onAppear(perform: {
                    let placeholderCoords = CGRect(x: geo.frame(in: .global).minX, y: geo.frame(in: .global).minY, width: 60, height: 60)
                    if let _ = dropSpots[qNum] {
                        dropSpots[qNum]!.append(placeholderCoords)
                    } else {
                        dropSpots[qNum] = [placeholderCoords]
                    }
                })
                .onDisappear(perform: {
                    dropSpots[qNum] = []
                })
        }
    }
}
