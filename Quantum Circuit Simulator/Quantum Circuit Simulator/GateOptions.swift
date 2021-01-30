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
    @Binding var draggedGate: String
    @Binding var originOfDrag: CGFloat
    
    @Binding var isAlerting: Bool
    @Binding var alert: Alert
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(gates, id: \.self, content: {option in
                    GeometryReader { geo in
                        
                        Gate(gateName: option, isDragging: $isDragging, draggedGate: $draggedGate, originOfDrag: $originOfDrag, circuit: $circuit)
                            .overlay(Image(systemName: "info.circle")
                                        .offset(x: 25, y: -15)
                                        .onTapGesture {
                                            alert = Alert(title: Text(Constants.names[option]!), message: Text(Constants.explanations[option]!), dismissButton: .default(Text("Okay")))
                                            
                                            isAlerting = true
                                        }
                            )
                            .alert(isPresented: $isAlerting) {
                                alert
                            }
                    }.frame(width: 55, height: 55)
                })
            }
        }
    }
}
