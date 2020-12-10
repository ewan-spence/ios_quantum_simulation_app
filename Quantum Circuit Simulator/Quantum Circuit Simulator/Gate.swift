//
//  Gate.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 02/12/2020.
//

import SwiftUI

struct Gate: View {
    @State var gateName : String
    
    var body: some View {
        Text(gateName)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10.0)
                        .stroke(Color.secondary)
                        .frame(width: 50, height: 50))
            .padding(.leading)
    }
}
