//
//  ContentView.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 21/10/2020.

import SwiftUI
import Alamofire

struct ContentView: View {
	@State var gates: [String] = Constants.gates
	
	@State var dropSpots: [CGRect] = []
		
	// Circuit is formatted as follows:
	// Each item in the outer list is a 'column' of the visual circuit,
	// Each item in each inner list is either '0' or the gate as represented in Constants.gates
	// For example:
	//					 ┌───┐
	//				q_0: ┤ H ├──■──────
	//					 └───┘┌─┴─┐
	//				q_1: ─────┤ X ├───
	//						  └───┘
	// Would be represented as
	// [['H', '0'], ['.', 'X']]
	@State var circuit: [[String]] = [[]]
	// Some statements about this implementation:
	// 		1. The number of qubits/wires = the `count` of each inner list
	//		2. To check for connected control gates, we only need check the next element of the list
	//		3. The ith qubit/wire is represented by the ith element of every inner list
	//		4. Adding a qubit/wire is equivalent to adding a 0 to every column
	//		5. Deleting the ith qubit/wire is equivalent to removing the ith element of every column
	
	@State var isDragging = false
	@State var draggedGate = ""
	
	@State var isAlerting = false
	@State var alert = Alert(title: Text("Unknown Error"))
	
	var body: some View {
		ZStack{
			VStack {
				Divider()
				
				GateOptions(gates: gates, circuit: $circuit, isDragging: $isDragging, dropSpots: $dropSpots, draggedGate: $draggedGate, isAlerting: $isAlerting, alert: $alert)
					.padding()
				
				Divider()
				
				CircuitView(circuit: $circuit, dropSpots: $dropSpots, isDragging: $isDragging, draggedGate: $draggedGate)
				
				Spacer()
			}
			
			VStack {
				
				Spacer()
				
				HStack {
					Spacer()
					
					Button("Execute", action: {})
						.padding()
						.background(
							RoundedRectangle(cornerRadius: 12)
								.foregroundColor(.white)
						)
						.padding(.trailing)
				}
			}
		}
	}
	
	func submitToApi() {
		let url = Constants.url
		
		let qasmString = Constants.circuitToQasm(circuit: circuit)
		
		AF.request(url, method: .post, parameters: ["qasm": qasmString], encoder: JSONParameterEncoder.default).responseJSON { response in
			
			switch response.result {
			case let .success(value):
				break
				
			case let .failure(error):
				break
			}
		}
		
	}
	
	
}

struct GateDropDelegate: DropDelegate {
	@Binding var dropSpots: [CGRect]
	
	@Binding var circuit: [[String]]
	
	@State var draggedGate: String
		
	@Binding var active: Int
		
	func validateDrop(info: DropInfo) -> Bool {

		return true
	}
	
	func performDrop(info: DropInfo) -> Bool {
		
		let location = CGPoint(x: info.location.x, y: info.location.y)
	
		print(location)
		for index in 0..<dropSpots.count {
			let spot = dropSpots[index]
			if spot.contains(location) {
				self.active = index
				
				circuit[active].append(draggedGate)
			}
		}
		dropSpots = []
		return true
	}
	
	func isInside(point: CGPoint, bounds: (CGPoint, CGPoint)) -> Bool {
		return (bounds.0.x < point.x) && (point.x < bounds.1.x) && (bounds.0.y < point.y) && (point.y < bounds.1.y)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.previewLayout(.fixed(width: 2436 / 3.0, height: 1125 / 3.0))
	}
}

