//
//  Gate.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 02/12/2020.
//

import SwiftUI

struct Gate: View {
    @State var gateName : String
    
    @State var qNum: Int?
    
    @State private var active = 0
    
    @Binding var isDragging: Bool
    @Binding var draggedGate: String
    
    @Binding var circuit: [[String]]
    
    var body: some View {
        if let _ = qNum {
            ZStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(Color.secondary)
                    .frame(width: 50, height: 50)
                    .overlay(Text(gateName))
                
            }
            .background(Color.white)
            .padding(.leading)
            .contextMenu(ContextMenu(menuItems: {
                Button("Delete Gate", action: {
                    
                })
            }))
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(Color.secondary)
                    .frame(width: 50, height: 50)
                    .overlay(Text(gateName))
                
            }
            .background(Color.white)
            .padding(.leading)
            
        }
        
    }
    
    func isInside(point: CGPoint, bounds: (CGPoint, CGPoint)) -> Bool {
        return (bounds.0.x < point.x) && (point.x < bounds.1.x) && (bounds.0.y < point.y) && (point.y < bounds.1.y)
    }
}
