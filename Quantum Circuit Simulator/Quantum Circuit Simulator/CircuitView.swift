//
//  CircuitView.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 02/12/2020.
//

import SwiftUI

struct CircuitView: View {
    @State var numQubits: Int = 1
    
    @State var qubits: [Int] = [1]
    
    @State var circuit: [Int: [String]] = [1:[]]
    
    var body: some View {
        ScrollView([.horizontal, .vertical]){
            VStack {
                ForEach(qubits, id: \.self, content: {qNum in
                    Wire(qNum: qNum, gates: circuit[qNum]!)
                        .contextMenu(ContextMenu(menuItems: {
                            Text("Delete Wire")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    var temp = qNum
                                    while circuit[temp+1] != nil {
                                        circuit[temp] = circuit[temp+1]
                                        temp += 1
                                    }
                                }
                        }))
                })
                
                HStack {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 25))
                        .onTapGesture(perform: {
                            circuit[numQubits + 1] = []
                            numQubits += 1
                        })
                    Spacer()
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

struct CircuitView_Previews: PreviewProvider {
    static var previews: some View {
        CircuitView()
    }
}
