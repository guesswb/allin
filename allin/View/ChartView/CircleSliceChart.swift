//
//  CircleSliceChart.swift
//  allin
//
//  Created by 김기훈 on 2023/05/25.
//

import SwiftUI

struct CircleSliceChart: View {
    
    let circleSliceData: CircleChart.CircleSliceData
    
    var midRadians: Double {
        return Double.pi / 2.0 - (circleSliceData.startAngle + circleSliceData.endAngle).radians / 2.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width: CGFloat = min(geometry.size.width, geometry.size.height)
                let height = width
                let center = CGPoint(x: width * 0.5, y: height * 0.5)
                
                path.move(to: center)
                
                path.addArc(
                    center: center,
                    radius: width * 0.5,
                    startAngle: Angle(degrees: -90.0) + circleSliceData.startAngle,
                    endAngle: Angle(degrees: -90.0) + circleSliceData.endAngle,
                    clockwise: false)
            }
            .fill(circleSliceData.color)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
