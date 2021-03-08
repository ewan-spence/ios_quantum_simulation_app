//
//  Constants.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 12/01/2021.
//

import Foundation

class Constants {
    static let gates = ["H", "X", "CX", "CCX"]
    static let names = ["H": "Hadamard", "X": "Pauli-X", "CX": "CNOT", "CCX": "Toffoli"]
    static let explanations = ["H": "This gate sets the probability of each state (|0> and |1>) to 0.5, making a value of 0 or 1 equally likely.",
                               "X": "This gate is the equivalent of a Classical NOT gate. I.e, it flips the value of the input qubit.",
                               "CX": "This gate flips the target qubit if and only if the control qubit is ON.\nDrag this to the location of the Target qubit.",
                               "CCX": "This gate flips the target qubit if and only if both control qubits are ON.\nDrag this to the location of the Target qubit."]
    
    static let url = "http://api.ewan-spence.com/execute/"
    
    private static var qasmString: String = ""
    
    public static func circuitToQasm(circuit: [[String]]) -> String {
        qasmString = "OPENQASM 2.0;\ninclude \"qelib1.inc\";\n"
        let numQBits = circuit[0].count
        
        qasmString.append("qreg q[\(numQBits)];\n")
        qasmString.append("creg c[\(numQBits)];\n")
        
        let gateApps = circuitToGateApplications(circuit: circuit)
        
        for app in gateApps {
            var lineString = String(repeating: "c", count: app.control.count)
            
            lineString.append(app.id + " ")
            
            app.control.forEach({controlQNum in
                lineString.append("q[\(String(controlQNum))], ")
            })
            
            lineString.append("q[\(String(app.target))]")
            qasmString.append(lineString + ";\n")
        }
        
        for qNum in 0..<numQBits {
            qasmString.append("measure q[\(qNum)] -> c[\(qNum)];\n")
        }
        
        return qasmString
    }
    
    public static func circuitToGateApplications(circuit: [[String]]) -> [GateApplication] {
        var gateApps: [GateApplication] = []
        
        for columnIndex in 0..<circuit.count {
            var column = circuit[columnIndex]
            
            var appMap: [Int: Int] = [:]
            
            for qNum in 0..<column.count {
                if (column[qNum].hasPrefix(".")) {
                    let targetQNum = Int(column[qNum].suffix(1))!
                    
                    if (appMap.keys.contains(targetQNum)) {                        
                        gateApps[appMap[targetQNum]!].control.append(qNum)
                    } else {
                        let id = column[targetQNum].lowercased()
                        
                        let app = GateApplication(id: id, target: targetQNum, control: [qNum])
                        
                        gateApps.append(app)
                        appMap[targetQNum] = gateApps.count-1
                        
                        column[targetQNum] = "0"
                    }
                    
                    column[qNum] = "0"
                }
            }
            
            for qNum in 0..<column.count {
                let gate = column[qNum]
                
                if gate != "0" {
                    gateApps.append(GateApplication(id: gate.lowercased(), target: qNum, control: []))
                }
            }
        }
        
        return gateApps
    }
    
    struct GateApplication {
        var id: String
        var target: Int
        var control: [Int]
    }
}
