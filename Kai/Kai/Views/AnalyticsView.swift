import SwiftUI
import Charts

struct AnalyticsView: View {
    @StateObject private var financialModel = FinancialModel()
    @State private var selectedTimeframe: Timeframe = .monthly
    
    enum Timeframe: String, CaseIterable {
        case weekly = "Weekly"
        case monthly = "Monthly"
        case yearly = "Yearly"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Savings Rate Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Savings Rate")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        let savingsRate = (financialModel.financialData.monthlyIncome - financialModel.financialData.monthlyExpenses) / financialModel.financialData.monthlyIncome
                        
                        HStack {
                            Text("\(Int(savingsRate * 100))%")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.green)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("Monthly Savings")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("$\(financialModel.financialData.monthlyIncome - financialModel.financialData.monthlyExpenses, specifier: "%.2f")")
                                    .font(.title3)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    
                    // Investment Portfolio
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Investment Portfolio")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(financialModel.financialData.investmentPortfolio) { investment in
                            InvestmentRow(investment: investment)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    
                    // Financial Goals Progress
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Goals Progress")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(financialModel.financialData.financialGoals) { goal in
                            GoalProgressRow(goal: goal)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    
                    // Spending Categories
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Spending Categories")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Chart {
                            ForEach(sampleSpendingData) { category in
                                SectorMark(
                                    angle: .value("Amount", category.amount),
                                    innerRadius: .ratio(0.5),
                                    angularInset: 1.5
                                )
                                .foregroundStyle(by: .value("Category", category.name))
                            }
                        }
                        .frame(height: 200)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                }
                .padding()
            }
            .navigationTitle("Analytics")
        }
    }
}

struct InvestmentRow: View {
    let investment: Investment
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(investment.name)
                    .foregroundColor(.white)
                Text(investment.type.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("$\(investment.amount, specifier: "%.2f")")
                    .foregroundColor(.green)
                Text("\(Int(investment.expectedReturn * 100))% return")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct GoalProgressRow: View {
    let goal: FinancialGoal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(goal.name)
                    .foregroundColor(.white)
                Spacer()
                Text("\(Int(goal.progress * 100))%")
                    .foregroundColor(.green)
            }
            
            ProgressView(value: goal.progress)
                .tint(.green)
            
            HStack {
                Text("$\(goal.currentAmount, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.green)
                Spacer()
                Text("$\(goal.targetAmount, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct SpendingCategory: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
}

let sampleSpendingData = [
    SpendingCategory(name: "Housing", amount: 2000),
    SpendingCategory(name: "Food", amount: 800),
    SpendingCategory(name: "Transportation", amount: 500),
    SpendingCategory(name: "Entertainment", amount: 300),
    SpendingCategory(name: "Utilities", amount: 400),
    SpendingCategory(name: "Other", amount: 1000)
] 