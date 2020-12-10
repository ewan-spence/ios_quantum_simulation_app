//
//  ContentView.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 21/10/2020.

import SwiftUI

struct ContentView: View {
	
	var body: some View {
		ZStack{
			VStack {
				Divider()
				
				GateOptions()
					.padding()
				
				Divider()
				
				CircuitView()
				
				Spacer()
			}
			
			VStack {
				
				Spacer()
				
				HStack {
					Spacer()
					
					Button("Execute", action: {})
						.padding()
						.overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.secondary))
						.padding(.trailing)
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.previewDevice("iPhone 11")
			.previewLayout(.fixed(width: 2436 / 3.0, height: 1125 / 3.0))
	}
}

