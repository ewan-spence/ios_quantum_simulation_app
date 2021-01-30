//
//  Wire.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 02/12/2020.
//

import SwiftUI

struct Wire: View {
    @State var qNum: Int
    @Binding var dropSpots: [Int: [CGRect]]
    @Binding var circuit: [[String]]
    
    @State private var active: Int = -1
    
    @Binding var isDragging: Bool
    @Binding var draggedGate: String
    
    var screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        if qNum < circuit[0].count {
            
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
                        ForEach(0..<circuit.count, id: \.self) {colIndex in
                            if (circuit[colIndex][qNum] != "0") {
                                Gate(gateName: circuit[colIndex][qNum], qNum: qNum, colNum: colIndex, isDragging: .constant(false), draggedGate: .constant(""), originOfDrag: .constant(0), circuit: $circuit)
                            } else {
                                if isDragging {
                                    DropArea(qNum: qNum, dropSpots: $dropSpots)
                                        .padding(.leading)
                                    Spacer()
                                }
                            }
                        }
                        
                        if (circuit.last![qNum] != "0") {
                            if isDragging {
                                DropArea(qNum: qNum, dropSpots: $dropSpots)
                                    .padding(.leading)
                                Spacer()
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
        }
    }
}
