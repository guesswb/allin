//
//  ChartView.swift
//  allin
//
//  Created by 김기훈 on 2023/05/25.
//

import SwiftUI
import Combine

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
        var result: RecommendedResult
    }
    
    var body: some View {
        VStack(spacing: 30) {
            ChartPicker(chartStyle: $chartStyle)
    
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.recommendedResult, id: \.id) { result in
                        Text("\(result.round)회")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.largeTitle)
                        
                        switch chartStyle {
                        case .circle: CircleChart(result: result)
                        default: OtherCharts(result: result, chartStyle: chartStyle)
                        }

                        ChartResult(chartResults: ChartResultData(
                            colors: ChartSource.Color.colors,
                            names: ChartSource.Text.rank,
                            result: result))
                    }
                    
                    LazyVStack {
                        if viewModel.fetchDataStatus != .lastPage {
                            ProgressView()
                                .onAppear {
                                    viewModel.request()
                                }
                        }
                    }
                }
            }
            .shadow(radius: 10)
            .onReceive(viewModel.$fetchDataStatus) { status in
                switch status {
                case .failFetch: toast = Toast(type: .error, title: "!", message: "데이터를 불러오는데 실패했습니다.")
                case .success: toast = nil
                case .lastPage: toast = Toast(type: .info, title: "!", message: "마지막 페이지입니다.")
                }
            }
            .toastView(toast: $toast)
        }
        .padding()
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(viewModel: ChartViewModel(service: ChartService(recommendedResultRepository: RecommendedResultRepository())))
    }
}
