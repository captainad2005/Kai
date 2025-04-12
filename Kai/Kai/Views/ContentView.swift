import SwiftUI
import Charts

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var currentBalance: Double = 0
    @State private var monthlyIncome: Double = 0
    @State private var monthlyExpenses: Double = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
                .tag(0)
            
            WhatIfView()
                .tabItem {
                    Label("What If", systemImage: "questionmark.circle.fill")
                }
                .tag(1)
            
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.pie.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
        .accentColor(.green)
        .preferredColorScheme(.dark)
    }
}

struct DashboardView: View {
    @State private var currentBalance: Double = 50000
    @State private var monthlyIncome: Double = 8000
    @State private var monthlyExpenses: Double = 5000
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Balance Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Current Balance")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("$\(currentBalance, specifier: "%.2f")")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Monthly Income")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("$\(monthlyIncome, specifier: "%.2f")")
                                    .font(.title3)
                                    .foregroundColor(.green)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("Monthly Expenses")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("$\(monthlyExpenses, specifier: "%.2f")")
                                    .font(.title3)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    
                    // Quick Actions
                    HStack(spacing: 20) {
                        QuickActionButton(title: "Add Income", icon: "plus.circle.fill", color: .green)
                        QuickActionButton(title: "Add Expense", icon: "minus.circle.fill", color: .red)
                        QuickActionButton(title: "What If", icon: "questionmark.circle.fill", color: .blue)
                    }
                    .padding()
                    
                    // Financial Goals
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Financial Goals")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        GoalProgressView(title: "Emergency Fund", progress: 0.7, target: 10000)
                        GoalProgressView(title: "Retirement", progress: 0.3, target: 500000)
                        GoalProgressView(title: "New Car", progress: 0.5, target: 30000)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                }
                .padding()
            }
            .navigationTitle("Financial Time Machine")
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
        }
        .frame(width: 100, height: 80)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct GoalProgressView: View {
    let title: String
    let progress: Double
    let target: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .foregroundColor(.white)
            
            ProgressView(value: progress)
                .tint(.green)
            
            HStack {
                Text("$\(target * progress, specifier: "%.2f")")
                    .foregroundColor(.green)
                Spacer()
                Text("$\(target, specifier: "%.2f")")
                    .foregroundColor(.gray)
            }
            .font(.caption)
        }
    }
}

