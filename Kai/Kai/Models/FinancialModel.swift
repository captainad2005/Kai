import Foundation

struct FinancialData: Identifiable {
    let id = UUID()
    var currentBalance: Double
    var monthlyIncome: Double
    var monthlyExpenses: Double
    var savingsRate: Double
    var investmentPortfolio: [Investment]
    var financialGoals: [FinancialGoal]
}

struct Investment: Identifiable {
    let id = UUID()
    var name: String
    var amount: Double
    var type: InvestmentType
    var expectedReturn: Double
}

enum InvestmentType: String, CaseIterable {
    case stocks = "Stocks"
    case bonds = "Bonds"
    case realEstate = "Real Estate"
    case crypto = "Cryptocurrency"
    case other = "Other"
}

struct FinancialGoal: Identifiable {
    let id = UUID()
    var name: String
    var targetAmount: Double
    var currentAmount: Double
    var deadline: Date
    var priority: Priority
    
    var progress: Double {
        return currentAmount / targetAmount
    }
}

enum Priority: String, CaseIterable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}

class FinancialModel: ObservableObject {
    @Published var financialData: FinancialData
    
    init() {
        self.financialData = FinancialData(
            currentBalance: 50000,
            monthlyIncome: 8000,
            monthlyExpenses: 5000,
            savingsRate: 0.3,
            investmentPortfolio: [
                Investment(name: "Tech Stocks", amount: 10000, type: .stocks, expectedReturn: 0.1),
                Investment(name: "Government Bonds", amount: 5000, type: .bonds, expectedReturn: 0.03)
            ],
            financialGoals: [
                FinancialGoal(name: "Emergency Fund", targetAmount: 10000, currentAmount: 7000, deadline: Date().addingTimeInterval(60*60*24*180), priority: .high),
                FinancialGoal(name: "Retirement", targetAmount: 500000, currentAmount: 150000, deadline: Date().addingTimeInterval(60*60*24*365*30), priority: .high),
                FinancialGoal(name: "New Car", targetAmount: 30000, currentAmount: 15000, deadline: Date().addingTimeInterval(60*60*24*365*2), priority: .medium)
            ]
        )
    }
    
    func calculateProjection(years: Int) -> [Double] {
        var projections: [Double] = []
        var currentAmount = financialData.currentBalance
        
        for _ in 0..<years {
            let yearlySavings = (financialData.monthlyIncome - financialData.monthlyExpenses) * 12
            let investmentReturns = financialData.investmentPortfolio.reduce(0) { $0 + ($1.amount * $1.expectedReturn) }
            currentAmount += yearlySavings + investmentReturns
            projections.append(currentAmount)
        }
        
        return projections
    }
    
    func whatIfScenario(incomeChange: Double, expenseChange: Double, investmentChange: Double) -> [Double] {
        var modifiedData = financialData
        modifiedData.monthlyIncome *= (1 + incomeChange)
        modifiedData.monthlyExpenses *= (1 + expenseChange)
        modifiedData.investmentPortfolio = modifiedData.investmentPortfolio.map { investment in
            var modifiedInvestment = investment
            modifiedInvestment.expectedReturn *= (1 + investmentChange)
            return modifiedInvestment
        }
        
        var projections: [Double] = []
        var currentAmount = modifiedData.currentBalance
        
        for _ in 0..<5 {
            let yearlySavings = (modifiedData.monthlyIncome - modifiedData.monthlyExpenses) * 12
            let investmentReturns = modifiedData.investmentPortfolio.reduce(0) { $0 + ($1.amount * $1.expectedReturn) }
            currentAmount += yearlySavings + investmentReturns
            projections.append(currentAmount)
        }
        
        return projections
    }
} 