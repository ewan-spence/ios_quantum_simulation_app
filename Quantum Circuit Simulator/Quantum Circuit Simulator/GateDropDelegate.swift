//
//  GateDropDelegate.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 16/04/2021.
//

import Foundation
import SwiftUI

struct GateDropDelegate: DropDelegate {
    @State var dropSpots: [Int: [CGRect]]
    @Binding var circuit: [[String]]
    
    @Binding var isDragging: Bool
    @State var draggedGate: String
    @State var originOfDrag: CGPoint
    @Binding var pos: CGPoint?
    @Binding var isAskingForM: Bool
    
    func performDrop(info: DropInfo) -> Bool {
        isDragging = false
        
        let ycoord = info.location.y - originOfDrag.y
        let xcoord = info.location.x
        
        let dropLocation = CGPoint(x: xcoord, y: ycoord)
        
        let qNumOptional = findSpotQNum(dropLocation: dropLocation)
        
        guard let qNum = qNumOptional else {
            return false
        }
        
        for colIndex in 0..<circuit.count {
            if circuit[colIndex][qNum] == "0" {
                
                if draggedGate == "R(m)" {
                    pos = CGPoint(x: colIndex, y: qNum)
                    isAskingForM = true
                    return true
                }
                circuit[colIndex][qNum] = draggedGate
                
                circuit.append(Array(repeating: "0", count: circuit[colIndex].count))
                return true
            }
        }
        
        var newCol = Array(repeating: "0", count: circuit[0].count)
        
        if draggedGate == "R(m)" {
            pos = CGPoint(x: circuit.count, y: qNum)    // qNum numbering starts at 0, .count starts at 1
            isAskingForM = true
            circuit.append(newCol)
            debugPrint(circuit)
            return true
        }
        newCol[qNum] = draggedGate
        
        circuit.append(newCol)
        
        return true
    }
    
    private func findSpotQNum(dropLocation: CGPoint) -> Int? {
        
        for qNum in 0..<dropSpots.keys.count {
            for spotIndex in 0..<dropSpots[qNum]!.count {
                let spot = dropSpots[qNum]![spotIndex]
                if spot.minY < dropLocation.y && dropLocation.y < spot.maxY &&
                    spot.minX < dropLocation.x && dropLocation.x < spot.maxX {
                    
                    return qNum
                }
            }
        }
        return nil
    }
}
