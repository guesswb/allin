//
//  CircleChart.swift
//  allin
//
//  Created by 김기훈 on 2023/05/25.
//

import SwiftUI

struct CircleChart: View {
    
    var values: [Double]
    
    struct CircleSliceData {
        var startAngle: Angle
        var endAngle: Angle
        var text: String
        var color: Color
    }
    
    var slices: [CircleSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [CircleSliceData] = []

        for (index, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(CircleSliceData(
                startAngle: Angle(degrees: endDeg),
                endAngle: Angle(degrees: endDeg + degrees),
                text: self.values[index] != 0 ? "\(ChartView.ChartSource.Text.rank[index])\n\(self.values[index])%" : "",
                color: Color(ChartView.ChartSource.Color.colors[index])))
            endDeg += degrees
        }
        return tempSlices
    }
    
    var body: some View {
        ZStack{
            ForEach(0..<8, id: \.self) { i in
                CircleSliceChart(circleSliceData: self.slices[i])
                CircleSliceChartText(circleSliceData: self.slices[i])
                    .zIndex(1)
            }
        }
    }
}
