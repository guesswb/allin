//
//  OtherCharts.swift
//  allin
//
//  Created by 김기훈 on 2023/05/25.
//

import SwiftUI
import Charts

struct OtherCharts: View {
    
    let result: RecommendedResult
    var chartStyle: ChartView.ChartSource.Style
    
    var body: some View {
        Chart {
            ForEach(0..<result.allCase.count, id: \.self) { index in
                if chartStyle == .bar {
                    BarMark(
                        x: .value("Name", ChartView.ChartSource.Text.rank[index]),
                        y: .value("Posting", result.allCase[index])
                    )
                    .foregroundStyle(Color(ChartView.ChartSource.Color.colors[index]))
                } else if chartStyle == .point {
                    PointMark(
                        x: .value("Posting", ChartView.ChartSource.Text.rank[index]),
                        y: .value("Name", result.allCase[index])
                    )
                    .foregroundStyle(Color(ChartView.ChartSource.Color.colors[index]))
                } else {
                    LineMark(
                        x: .value("Name", ChartView.ChartSource.Text.rank[index]),
                        y: .value("Posting", result.allCase[index])
                    )
                }
            }
        }
    }
}
