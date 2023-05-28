//
//  ChartPicker.swift
//  allin
//
//  Created by 김기훈 on 2023/05/28.
//

import SwiftUI

struct ChartPicker: View {
    
    @Binding var chartStyle: ChartView.ChartSource.Style
    
    var body: some View {
        Picker("Style", selection: $chartStyle) {
            ForEach(ChartView.ChartSource.Style.allCases, id: \.self) {
                Text("\($0.rawValue)")
            }
        }
        .pickerStyle(.segmented)
    }
}
