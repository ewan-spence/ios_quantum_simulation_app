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
    @State var colNum: Int?
    
    @State private var active = 0
    
    @Binding var isDragging: Bool
    @Binding var draggedGate: String
    @Binding var originOfDrag: CGPoint
    
    @Binding var circuit: [[String]]
    @State var connectedQNums: [Int] = []
    
    var body: some View {
        if let qNum = qNum {
            if gateName.hasPrefix(".") {
                ZStack {
                    Image(systemName: "circle.fill.square.fill")
                        .frame(width: 50, height: 50)
                    
                    ForEach(connectedQNums, id: \.self) {targetQNum in
                        Rectangle()
                            .frame(width: 1, height: CGFloat((targetQNum - qNum)) * 50)
                    }
                }
                .background(Color("primary"))
                .padding(.leading)
                .contextMenu(ContextMenu(menuItems: {
                    Button("Delete Gate", action: deleteGate)
                }))
                .onAppear {
                    connectedQNums = gateName.dropFirst()       // Remove the '.'
                        .components(separatedBy: "")            // Split to get list of relevent qNums as [String]
                        .map({qString in return Int(qString)!}) // Cast to [Int]
                }
            } else {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(Color("secondary"))
                        .frame(width: 50, height: 50)
                        .overlay(Text(gateName))
                }
                .background(Color("primary"))
                .padding(.leading)
                .contextMenu(ContextMenu(menuItems: {
                    Button("Delete Gate", action: deleteGate)
                }))
                
                
            }
        } else {
            GeometryReader { geo in
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(Color("secondary"))
                        .frame(width: 50, height: 50)
                        .overlay(Text(gateName))
                    
                }
                .background(Color("primary"))
                .onDrag({
                    isDragging = true
                    draggedGate = gateName
                    originOfDrag = CGPoint(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).minY)
                    print(originOfDrag)
                    return NSItemProvider()
                })
                .padding(.leading)
            }
        }
    }
    
    func deleteGate() {    
        if let colNum = colNum, let qNum = qNum {
            circuit[colNum][qNum] = "0"
        }
    }
}
