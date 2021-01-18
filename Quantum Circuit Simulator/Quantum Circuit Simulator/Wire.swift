//
//  Wire.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 02/12/2020.
//

import SwiftUI

struct Wire: View {
    @State var qNum: Int
    @Binding var dropSpots: [CGRect]
    @Binding var circuit: [[String]]
    @State var gates: [String]
    
    @State private var active: Int = -1
    
    @Binding var isDragging: Bool
    @Binding var draggedGate: String
    
    var screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        HStack {
            HStack {
                (Text("Q")
                    .font(.system(size: 20))
                    +
                    Text(String(qNum))
                    .font(.system(size: 15))
                    .baselineOffset(-1))
            }.padding()
            
            Spacer()
            
            ZStack {
                Rectangle()
                    .frame(width: screenWidth * 0.8, height: 1)
                    .padding(.trailing)
                HStack {
                    ForEach(gates, id: \.self) {gate in
                        if (gate != "0") {
                            Gate(gateName: gate, qNum: qNum, isDragging: $isDragging, draggedGate: $draggedGate, circuit: $circuit)
                        }
                    }
                }
            }
        }
        .onAppear {
            circuit.forEach({column in
                gates.append(column[qNum])
            })
        }
    }
}



struct Wire_Previews: PreviewProvider {
    static var previews: some View {
        Wire(qNum: 0, dropSpots: .constant([]), circuit: .constant([["H"], ["0"]]), gates: ["H"], isDragging: .constant(false), draggedGate: .constant(""))
    }
}
