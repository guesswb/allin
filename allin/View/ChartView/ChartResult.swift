//
//  ChartResult.swift
//  allin
//
//  Created by 김기훈 on 2023/05/25.
//

import SwiftUI

struct ChartResult: View {
    
    let chartResults: ChartView.ChartResultData
    
    var body: some View {
        VStack {
            ForEach(0..<chartResults.values.count, id: \.self) { index in
                HStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color(chartResults.colors[index]))
                        .frame(width: 20, height: 20)
                    Text(chartResults.names[index])
        
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("\(Int(chartResults.values[index]))")
                        Text(String(format: "%.2f", chartResults.values[index] / chartResults.sumValues * 100) + "%")
                            .foregroundColor(Color.gray)
                    }
                }
            }
        }
    }
}
