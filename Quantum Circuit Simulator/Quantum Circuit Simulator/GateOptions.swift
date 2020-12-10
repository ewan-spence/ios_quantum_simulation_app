//
//  GateOptions.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 02/12/2020.
//

import SwiftUI

struct GateOptions: View {
    @State private var availableGates: [String] = ["H", "X", "CX"]
    
    var body: some View {
        ScrollView(.horizontal) {
            
            HStack {
                ForEach(availableGates, id: \.self, content: {option in
                    Gate(gateName: option)
                })
            }
        }
    }
}

struct GateOptions_Previews: PreviewProvider {
    static var previews: some View {
        GateOptions()
    }
}
