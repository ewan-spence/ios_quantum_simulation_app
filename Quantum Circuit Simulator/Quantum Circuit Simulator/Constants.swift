//
//  Constants.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 12/01/2021.
//

import Foundation
import Numerics
import BarChart

class Constants {
    static let gates = ["H", "X", "Y", "Z", "R(m)"]
    static let names = ["H": "Hadamard", "X": "Pauli-X", "Y": "Pauli-Y", "Z": "Pauli-Z", "R(m)" : "Phase Gate"]
    static let explanations = ["H": "This gate sets the probability of each state (|0> and |1>) to 0.5, making a value of 0 or 1 equally likely.",
                               "X": "This gate is the equivalent of a Classical NOT gate. I.e, it flips the value of the input qubit.",
                               "Y": "This explanation will be added shortly.", //TODO
                               "Z": "This explanation will be added shortly.", //TODO
                               "R(m)": "This gate performs a rotation in the z-axis based on an angle determined by a parameter m."]
    
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
    
    private static func circuitToGateApplications(circuit: [[String]]) -> [GateApplication] {
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
                } else if (column[qNum].hasPrefix("R")) {
                    let mSide = column[qNum].split(separator: "(")[1]
                    
                    let m = Int(mSide.dropLast())!
                    
                    let lambda = convert(toLambda: m)
                    
                    let app = GateApplication(id: "u1(\(lambda))", target: qNum, control: [])
                    gateApps.append(app)
                    
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
    
    private static func convert(toLambda m: Int) -> Double {
        let num = 2.0 * Double.pi
        let denom = pow(2.0, Double(m))
        
        return num/denom
    }
    
    static func addZeroValues(_ res: inout [String: Int], circuit: [[String]])  {
        let numWires = circuit[0].count
                
        var allBinaryStrings = [String]()
        var initialString = ""
        
        genBinaryStrings(numWires, &initialString, 0, &allBinaryStrings)
        
        for str in allBinaryStrings {
            if !res.keys.contains(str) {
                res[str] = 0
            }
        }
    }
    
    static func genBinaryStrings(_ strLen: Int, _ string: inout String, _ i: Int, _ array: inout [String]) {
        if i == strLen {
            array.append(string)
            return
        }
        
        let originalString = string
        
        string.append("0")
        genBinaryStrings(strLen, &string, i + 1, &array)
        
        string = originalString
        string.append("1")
        genBinaryStrings(strLen, &string, i + 1, &array)
    }
     
    static func arrayToDataEntries(_ array : Array<(key: String, value: Int)>) -> [ChartDataEntry] {
        var out: [ChartDataEntry] = []
        
        for entry in array {
            out.append(ChartDataEntry(x: entry.key, y: Double(entry.value)))
        }
        
        return out
    }
    
    struct GateApplication {
        var id: String
        var target: Int
        var control: [Int]
    }
}
