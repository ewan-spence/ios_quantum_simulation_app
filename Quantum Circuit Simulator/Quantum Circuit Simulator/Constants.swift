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
                               "CX": "This gate flips the target qubit if and only if the control qubit is ON",
                               "CCX": "This gate flips the target qubit if and only if both control qubits are ON"]
    
    static let url = "www.example.com"
    
    private static var qasmString: String = "OPENQASM 2.0;\ninclude \"qelib1.inc\";\n"
    
    static func circuitToQasm(circuit: [[String]]) -> String {
        let numQBits = circuit[0].count
        
        qasmString.append("qreg q[\(numQBits)];\n")
        qasmString.append("creg c[1];\n")
        
        for columnIndex in 0..<circuit.count  {
            let column = circuit[columnIndex]
                        
            for qNum in 0..<column.count {
                let gate = column[qNum]
                switch gate {
                case "H":
                    qasmString.append("h q[\(columnIndex)]")
                    break
                case "X":
                    qasmString.append("x q[\(columnIndex)]")
                    break
                
                default:
                    break
                }
            }
        }
        
        return qasmString
    }
}
