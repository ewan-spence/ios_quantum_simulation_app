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
	@State var results: [String: Double] = [:]

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
				
				if isAskingForM {
					return
				}
				for var colIndex in 1..<circuit.count {
					colIndex = colIndex - numDeleted
					if circuit[colIndex].elementsEqual(Array(repeating: "0", count: circuit[colIndex].count)) {
						circuit.remove(at: colIndex)
						numDeleted += 1
					}
				}
			})
			.textFieldAlert(isPresented: $isAskingForM, content: {
				TextFieldAlert(title: "Enter a value for m", message: "", text: $m, action: addRGate)
			})
		} else {
			ResultsView(isShowingCircuit: $isShowingCircuit, circuit: circuit, results: results)
		}
	}
	
	func addRGate() {
		circuit = _circuit.wrappedValue
		circuit[Int(circIndex!.x)][Int(circIndex!.y)] = "R(\(m!))"
	}
	
	func submitToApi() {
		let url = Constants.url
		
		let qasmString = Constants.circuitToQasm(circuit: circuit)
		
		let params = ["qasm": qasmString]
		
		debugPrint(params)
		
		AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default).responseDecodable(of: [String:Double].self) { response in
			
			switch response.result {
			case let .success(json):
				results = json
				isShowingCircuit = false
				break
				
			case let .failure(error):
				alert = Alert(title: Text("API Error"), message: Text("There was an error contacting the API.\nPlease try again.\nError message: \(error.errorDescription ?? "Unknown")"), dismissButton: .default(Text("Okay")))
				isAlerting = true
				return
			}
		}
		
	}
	
	
}

