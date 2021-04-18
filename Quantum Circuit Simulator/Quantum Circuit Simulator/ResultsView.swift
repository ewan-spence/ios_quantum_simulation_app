//
//  ResultsView.swift
//  Quantum Circuit Simulator
//
//  Created by Ewan Spence on 16/04/2021.
//

import SwiftUI
import BarChart

struct ResultsView: View {
    @Binding var isShowingCircuit: Bool
    
    let selectionIndicatorHeight: CGFloat = 60
    @State var selectedBarTopCentreLocation: CGPoint?
    @State var selectedEntry: ChartDataEntry?
    
    @State var circuit: [[String]]
    @State var results: [String: Double]
    
    var body: some View {
        let config = ChartConfiguration()
        
        VStack {
            HStack {
                Button("< Back", action: {isShowingCircuit = true})
                    .padding()
                Spacer()
            }
            
            Text("Chart of Measurement Probability of Qubits after 1000 Shots")
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            HStack {
                
                GeometryReader { proxy in
                    SelectableBarChartView<SelectionIndicator>(config: config)
                        .onBarSelection {entry, point in
                            self.selectedBarTopCentreLocation = point
                            self.selectedEntry = entry
                        }
                        .selectionView {
                            return SelectionIndicator(entry: self.selectedEntry, location: self.selectedBarTopCentreLocation)
                        }
                        .onAppear {
                            config.xAxis.ticksColor = Color("secondary")
                            config.xAxis.labelsColor = Color("secondary")
                            config.yAxis.ticksColor = Color("secondary")
                            config.yAxis.labelsColor = Color("secondary")
                            
                            config.data.entries = Constants.dictToDataEntries(results, circuit)
                        }
                        .padding()
                }
                
                Text("% of Measurements")
                    .rotationEffect(Angle(degrees: 90.0))
                    .padding(.trailing, -70)
                    .padding(.leading, -40)
                    .foregroundColor(Color("secondary"))
            }
            
            Text("Measured Values")
                .multilineTextAlignment(.center)
                .foregroundColor(Color("secondary"))
        }    }
}
