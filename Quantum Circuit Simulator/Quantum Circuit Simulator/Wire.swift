//
//  Wire.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 02/12/2020.
//

import SwiftUI

struct Wire: View {
    @State var qNum: Int
    
    @State var gates: [String] = []
    
    @State var isDragging: Bool = false
    @State var dropOffset: CGFloat = 12
    
    var screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        ZStack {
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
                        
                        ForEach(gates, id: \.self, content: {gate in
                            Gate(gateName: gate)
                        })
                        
                        if(isDragging) {
                            
                            Spacer()
                                .frame(width:12)
                            
                            Image(systemName: "plus.app.fill")
                                .font(.system(size: 45))
                                .background(Color.white)
                            
                            Spacer()
                        }
                    }
                    
                }
                
            }
        }
    }
}

struct Wire_Previews: PreviewProvider {
    static var previews: some View {
        Wire(qNum: 1)
    }
}
