//
//  GateOptions.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 02/12/2020.
//

import SwiftUI

struct GateOptions: View {
    @State var gates = Constants.gates
    
    @Binding var circuit: [[String]]
    
    @Binding var isDragging: Bool
    @Binding var dropSpots: [CGRect]
    @Binding var draggedGate: String
    
    @Binding var isAlerting: Bool
    @Binding var alert: Alert
    
    var body: some View {
        ScrollView(.horizontal) {
            
            HStack {
                ForEach(gates, id: \.self, content: {option in
                    Gate(gateName: option, isDragging: $isDragging, draggedGate: $draggedGate, circuit: $circuit)
                        .gesture(DragGesture(minimumDistance: 3, coordinateSpace: .global))
                        .overlay(Image(systemName: "info.circle")
                                    .offset(x: 23, y: -15)
                                    .onTapGesture {
                                        alert = Alert(title: Text(Constants.names[option]!), message: Text(Constants.explanations[option]!), dismissButton: .default(Text("Okay")))
                                        
                                        isAlerting = true
                                    }
                        )
                        .alert(isPresented: $isAlerting) {
                            alert
                        }
                })
            }
        }
    }
}
