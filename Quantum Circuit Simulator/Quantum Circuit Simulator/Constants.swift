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
    
    static let url = "www.example.com"
    
    private static var qasmString: String = "OPENQASM 2.0;\ninclude \"qelib1.inc\";\n"
    
    public static func circuitToQasm(circuit: [[String]]) -> String {
        let numQBits = circuit[0].count
        
        qasmString.append("qreg q[\(numQBits)];\n")
        qasmString.append("creg c[1];\n")
        
        for columnIndex in 0..<circuit.count  {
            let column = circuit[columnIndex]
                        
            for qNum in 0..<column.count {
                let gate = column[qNum]
                
                var op = ""
                var params = "q[\(qNum)]"
                
                switch gate {
                case "H":
                    op = "h"
                    break
                    
                case "X":
                    op = "x"
                    break
            
                case _ where column[qNum].hasPrefix("."):
                    
                    if column[qNum].count == 2 {
                        op = "cx"
                        
                        params += " q[\(column[qNum].suffix(1))]"
                    }
                    if column[qNum].count == 3 {
                        op = "ccx"
                        
                        let otherGates = Array(column[qNum].suffix(2))
                        let otherControl = otherGates[0]
                        let target = otherGates[1]
                        
                        params += " q[\(otherControl)] q[\(target)]"
                    }
                    
                    break
                default:
                    break
                }
                
                qasmString.append("\(op) \(params);\n")
            }
        }
        
        return qasmString
    }
}
