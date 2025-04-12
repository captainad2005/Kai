import SwiftUI
import Charts
import Foundation

struct WhatIfView: View {
    @StateObject private var financialModel = FinancialModel()
    @State private var incomeChange: Double = 0
    @State private var expenseChange: Double = 0
    @State private var investmentChange: Double = 0
    @State private var selectedTimeframe: Timeframe = .fiveYears
    
    private var currentProjection: [Double] {
        financialModel.calculateProjection(years: selectedTimeframe.years)
    }
    
    private var whatIfProjection: [Double] {
        financialModel.whatIfScenario(
            incomeChange: incomeChange,
            expenseChange: expenseChange,
            investmentChange: investmentChange
        )
    }
    
    enum Timeframe: String, CaseIterable {
        case oneYear = "1 Year"
        case threeYears = "3 Years"
        case fiveYears = "5 Years"
        case tenYears = "10 Years"
        
        var years: Int {
            switch self {
            case .oneYear: return 1
            case .threeYears: return 3
            case .fiveYears: return 5
            case .tenYears: return 10
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Scenario Controls
                    VStack(spacing: 15) {
                        Text("Adjust Your Scenario")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ScenarioSlider(title: "Income Change", value: $incomeChange, range: -0.5...0.5, step: 0.05)
                        ScenarioSlider(title: "Expense Change", value: $expenseChange, range: -0.5...0.5, step: 0.05)
                        ScenarioSlider(title: "Investment Return", value: $investmentChange, range: -0.5...0.5, step: 0.05)
                        
                        Picker("Timeframe", selection: $selectedTimeframe) {
                            ForEach(Timeframe.allCases, id: \.self) { timeframe in
                                Text(timeframe.rawValue).tag(timeframe)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.top)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    
                    // Projection Chart
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Projection")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Chart {
                            ForEach(Array(currentProjection.enumerated()), id: \.offset) { index, value in
                                LineMark(
                                    x: .value("Year", index + 1),
                                    y: .value("Value", value)
                                )
                                .foregroundStyle(.green)
                            }
                            
                            ForEach(Array(whatIfProjection.enumerated()), id: \.offset) { index, value in
                                LineMark(
                                    x: .value("Year", index + 1),
                                    y: .value("Value", value)
                                )
                                .foregroundStyle(.blue)
                            }
                        }
                        .frame(height: 200)
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    
                    // Key Metrics
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Key Metrics")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        let currentFinal = currentProjection.last ?? 0
                        let whatIfFinal = whatIfProjection.last ?? 0
                        let difference = whatIfFinal - currentFinal
                        
                        MetricRow(title: "Current Projection", value: currentFinal, color: .green)
                        MetricRow(title: "What If Projection", value: whatIfFinal, color: .blue)
                        MetricRow(title: "Difference", value: difference, color: difference >= 0 ? .green : .red)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                }
                .padding()
            }
            .navigationTitle("What If")
        }
    }
}

struct ScenarioSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.white)
            
            HStack {
                Text("\(Int(value * 100))%")
                    .foregroundColor(.gray)
                    .frame(width: 50)
                
                Slider(value: $value, in: range, step: step)
                    .tint(value >= 0 ? .green : .red)
            }
        }
    }
}

struct MetricRow: View {
    let title: String
    let value: Double
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Text("$\(value, specifier: "%.2f")")
                .foregroundColor(color)
        }
    }
} 