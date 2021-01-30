//
//  CircuitView.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 02/12/2020.
//

import SwiftUI

struct CircuitView: View {
    @Binding var circuit: [[String]]
    
    @Binding var dropSpots: [Int: [CGRect]]
    
    @Binding var isDragging: Bool
    @Binding var draggedGate: String
    
    var body: some View {
        ScrollView([.horizontal, .vertical]){
            VStack {
                ForEach(0..<circuit[0].count, id: \.self, content: {qNum in
                    Wire(qNum: qNum, dropSpots: $dropSpots, circuit: $circuit, isDragging: $isDragging, draggedGate: $draggedGate)
                        .contextMenu(menuItems: {
                            Button("Remove Wire", action: {
                                for columnIndex in 0..<circuit.count {
                                    circuit[columnIndex].remove(at: qNum)
                                }
                            })
                        })
                })
                
                HStack {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 25))
                        .onTapGesture(perform: {
                            for colIndex in 0..<circuit.count {
                                circuit[colIndex].append("0")
                            }
                        })
                        .disabled(circuit[0].count > 10)
                    Spacer()
                }
                .padding()
                
                Spacer()
                
            }
        }
    }
}
