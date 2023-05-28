//
//  ChartView.swift
//  allin
//
//  Created by 김기훈 on 2023/05/25.
//

import SwiftUI



struct ChartView: View {
    
    @StateObject var viewModel: ChartViewModel
    @State private var chartStyle: ChartSource.Style = .circle
    @State private var toast: Toast? = nil

    enum ChartSource {
        enum Style: String, CaseIterable {
            case circle = "원형"
            case bar = "바형"
            case point = "포인트형"
            case line = "선형"
        }
        
        enum Text {
            static let rank: [String] = ["1등", "2등", "3등", "4등", "5등", "2개 맞춤", "1개 맞춤", "0개 맞춤"]
        }
        
        enum Color {
            static let colors: [UIColor] = [.yellow, .systemGray6, .systemGray5, .systemGray4, .systemGray3, .systemGray2, .systemGray, .orange]
        }
    }
    
    struct ChartResultData {
        var colors: [UIColor]
        var names: [String]
        var values: [Double]
        var sumValues: Double
    }
    
    var body: some View {
        VStack(spacing: 30) {
            ChartPicker(chartStyle: $chartStyle)
    
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(0..<viewModel.lotteryRound.count, id: \.self) { index in
                        Text("\(viewModel.lotteryRound[index])회")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.largeTitle)
                        
                        switch chartStyle {
                        case .circle: CircleChart(values: viewModel.lotteryResult[index])
                        default: OtherCharts(values: viewModel.lotteryResult[index], chartStyle: chartStyle)
                        }
                        
                        ChartResult(chartResults: ChartResultData(
                            colors: ChartSource.Color.colors,
                            names: ChartSource.Text.rank,
                            values: viewModel.lotteryResult[index],
                            sumValues: viewModel.lotteryResult[index].reduce(0, +)))
                    }
                    
                    LazyVStack {
                        if viewModel.isLastPage == false {
                            ProgressView()
                                .onAppear {
                                    Task {
                                        await viewModel.request()
                                        toast = viewModel.isLastPage ? Toast(type: .info, title: "!", message: "마지막 페이지입니다.") : nil
                                    }
                                }
                        }
                    }
                }
            }
            .shadow(radius: 10)
            .toastView(toast: $toast)
        }
        .padding()
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(viewModel: ChartViewModel())
    }
}
