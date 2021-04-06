//
//  ContentView.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 21/10/2020.

import SwiftUI
import Alamofire
import BarChart

struct ContentView: View {
	@State var gates: [String] = Constants.gates
	
	@State var dropSpots: [Int: [CGRect]] = [:] // QNum : Rectangle
	
	// Circuit is formatted as follows:
	// Each item in the outer list is a 'column' of the visual circuit,
	// Each item in each inner list is either '0' or the gate as represented in Constants.gates
	// In the case of multiple qbit gates (CX/CCX etc.), the Control bit is represented as:
	// '.' followed by the qbit number of the other control (if present), followed by the qbit number of the target
	// For example:
	//					 ┌───┐
	//				q_0: ┤ H ├──■──────
	//					 └───┘┌─┴─┐
	//				q_1: ─────┤ X ├───
	//						  └───┘
	// Would be represented as
	// [['H', '0'], ['.1', 'X']]
	@State var circuit: [[String]] = [["0"]]
	// Some statements about this implementation:
	// 		1. The number of qubits/wires = the `count` of each inner list
	//		2. To check for connected control gates, we only need check the next element of the list
	//		3. The ith qubit/wire is represented by the ith element of every inner list
	//		4. Adding a qubit/wire is equivalent to adding a 0 to every column
	//		5. Deleting the ith qubit/wire is equivalent to removing the ith element of every column
	//		6. Deleting a gate is the equivalent of setting its value to 0
	//		7. Removing a control from a CX/CCX gate should work fine without any special adjustments
	
	@State var isDragging: Bool = false
	@State var draggedGate: String = ""
	@State var originOfDrag: CGPoint = CGPoint()
	
	@State var isAlerting: Bool = false
	@State var alert = Alert(title: Text("Unknown Error"))
	
	@State var isAskingForM: Bool = false
	@State var m: String?
	@State var circIndex: CGPoint?
	
	@State var isShowingCircuit: Bool = true
	@State var results: [String: Int] = [:]
	
	var body: some View {
		if isShowingCircuit {
			ZStack{
				VStack {
					Divider()
					
					GateOptions(gates: gates, circuit: $circuit, isDragging: $isDragging, draggedGate: $draggedGate, originOfDrag: $originOfDrag, isAlerting: $isAlerting, alert: $alert)
					
					Divider()
					
					CircuitView(circuit: $circuit, dropSpots: $dropSpots, isDragging: $isDragging, draggedGate: $draggedGate)
					
					Spacer()
				}
				
				VStack {
					
					Spacer()
					
					HStack {
						Spacer()
						
						Button("Execute", action: submitToApi)
							.padding()
							.background(
								RoundedRectangle(cornerRadius: 12)
									.foregroundColor(Color("secondary"))
							)
							.padding(.trailing)
					}
				}
			}
			.onDrop(of: [.text], delegate: GateDropDelegate(dropSpots: dropSpots, circuit: $circuit, isDragging: $isDragging, draggedGate: draggedGate, originOfDrag: originOfDrag, pos: $circIndex, isAskingForM: $isAskingForM))
			.onChange(of: circuit, perform: {_ in
				
				var numDeleted = 0
				
				for var colIndex in 1..<circuit.count {
					colIndex = colIndex - numDeleted
					if circuit[colIndex].elementsEqual(Array(repeating: "0", count: circuit[colIndex].count)) {
						circuit.remove(at: colIndex)
						numDeleted += 1
					}
				}
			})
			.textFieldAlert(isPresented: $isAskingForM, content: {
				TextFieldAlert(title: "Enter a value for m", message: "", text: $m, action: {
					circuit[Int(circIndex!.x)][Int(circIndex!.y)] = "R(\(m!))"
				})
			})
		} else {
			let config = ChartConfiguration()
			
			VStack {
				HStack {
					Button("< Back", action: {isShowingCircuit = true})
						.padding()
					Spacer()
				}
				
				Text("Chart of Measurements of Qubits after 1000 Shots")
					.multilineTextAlignment(.center)
					.padding(.bottom)
				
				HStack {
					BarChartView(config: config)
						.onAppear() {
							config.xAxis.ticksColor = Color("secondary")
							config.xAxis.labelsColor = Color("secondary")
							config.yAxis.ticksColor = Color("secondary")
							config.yAxis.labelsColor = Color("secondary")
							
							Constants.addZeroValues(&results, circuit: circuit)
							let sortedResults = Array(results).sorted(by: {$0.0 < $1.0})
							
							config.data.entries = Constants.arrayToDataEntries(sortedResults)
						}
						.padding()
					
					
					Text("Number of measurements")
						.rotationEffect(Angle(degrees: 90.0))
						.padding(.trailing, -70)
						.padding(.leading, -40)
						.foregroundColor(Color("secondary"))
				}
				
				Text("Measured Values")
					.multilineTextAlignment(.center)
					.foregroundColor(Color("secondary"))
			}
		}
	}
	
	func submitToApi() {
		let url = Constants.url
		
		let qasmString = Constants.circuitToQasm(circuit: circuit)
		
		AF.request(url, method: .post, parameters: ["qasm": qasmString], encoder: JSONParameterEncoder.default).responseJSON { response in
			
			switch response.result {
			case let .success(value):
				guard let json = value as? [String: Int] else {
					alert = Alert(title: Text("API Error"), message: Text("There was an error contacting the API.\nPlease try again."), dismissButton: .default(Text("Okay")))
					return
				}
				
				results = json
				isShowingCircuit = false
				break
				
			case let .failure(error):
				debugPrint(error)
				break
			}
		}
		
	}
	
	
}

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
		
		for qNum in 0..<dropSpots.keys.count {
			
			for spotIndex in 0..<dropSpots[qNum]!.count {
				let spot = dropSpots[qNum]![spotIndex]
				if spot.minY < ycoord && ycoord < spot.maxY &&
					spot.minX < xcoord && xcoord < spot.maxX {
					
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
						pos = CGPoint(x: circuit.count-1, y: qNum)	// qNum numbering starts at 0, .count starts at 1
						isAskingForM = true
						circuit.append(newCol)
						return true
					}
					newCol[qNum] = draggedGate
					
					circuit.append(newCol)
					
					return true
				}
			}
		}
		return false
	}
}
