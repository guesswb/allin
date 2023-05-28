//
//  CircleSliceChartText.swift
//  allin
//
//  Created by 김기훈 on 2023/05/28.
//

import SwiftUI

struct CircleSliceChartText: View {
    
    let circleSliceData: CircleChart.CircleSliceData
    
    var midRadians: Double {
        return Double.pi / 2.0 - (circleSliceData.startAngle + circleSliceData.endAngle).radians / 2.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            Text(circleSliceData.text)
                .position(
                    x: geometry.size.width * 0.5 * CGFloat(1.0 + 0.78 * cos(self.midRadians)),
                    y: geometry.size.height * 0.5 * CGFloat(1.0 - 0.78 * sin(self.midRadians))
                )
                .foregroundColor(.primary)
        }
    }
}
