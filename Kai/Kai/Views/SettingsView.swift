import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("currencySymbol") private var currencySymbol = "$"
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("biometricAuthEnabled") private var biometricAuthEnabled = true
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                    Picker("Currency", selection: $currencySymbol) {
                        Text("$ - USD").tag("$")
                        Text("€ - EUR").tag("€")
                        Text("£ - GBP").tag("£")
                        Text("¥ - JPY").tag("¥")
                    }
                }
                
                Section(header: Text("Security")) {
                    Toggle("Biometric Authentication", isOn: $biometricAuthEnabled)
                    Toggle("Notifications", isOn: $notificationsEnabled)
                }
                
                Section(header: Text("Data & Privacy")) {
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Text("Privacy Policy")
                    }
                    
                    NavigationLink(destination: TermsOfServiceView()) {
                        Text("Terms of Service")
                    }
                    
                    Button(action: {
                        // Export data functionality
                    }) {
                        Text("Export Data")
                    }
                    
                    Button(action: {
                        // Delete account functionality
                    }) {
                        Text("Delete Account")
                            .foregroundColor(.red)
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    
                    NavigationLink(destination: SupportView()) {
                        Text("Support")
                    }
                    
                    NavigationLink(destination: FeedbackView()) {
                        Text("Send Feedback")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Privacy Policy")
                    .font(.title)
                    .bold()
                
                Text("Last updated: April 12, 2024")
                    .foregroundColor(.gray)
                
                Group {
                    Text("1. Data Collection")
                        .font(.headline)
                    Text("We collect only the financial data you choose to input into the app. This includes income, expenses, investments, and financial goals.")
                    
                    Text("2. Data Storage")
                        .font(.headline)
                    Text("All your data is stored locally on your device. We do not store any of your financial information on our servers.")
                    
                    Text("3. Data Usage")
                        .font(.headline)
                    Text("Your data is used solely to provide you with financial insights and projections. We do not sell or share your data with third parties.")
                    
                    Text("4. Data Security")
                        .font(.headline)
                    Text("We implement industry-standard security measures to protect your data, including encryption and biometric authentication.")
                }
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Terms of Service")
                    .font(.title)
                    .bold()
                
                Text("Last updated: April 12, 2024")
                    .foregroundColor(.gray)
                
                Group {
                    Text("1. Acceptance of Terms")
                        .font(.headline)
                    Text("By using this app, you agree to these terms of service.")
                    
                    Text("2. User Responsibilities")
                        .font(.headline)
                    Text("You are responsible for maintaining the accuracy of your financial data and keeping your account secure.")
                    
                    Text("3. Disclaimer")
                        .font(.headline)
                    Text("This app provides financial projections and insights for informational purposes only. It is not financial advice.")
                    
                    Text("4. Limitation of Liability")
                        .font(.headline)
                    Text("We are not liable for any financial decisions made based on the app's projections or insights.")
                }
            }
            .padding()
        }
        .navigationTitle("Terms of Service")
    }
}

struct SupportView: View {
    var body: some View {
        List {
            Section(header: Text("Contact Us")) {
                Link("Email Support", destination: URL(string: "mailto:support@financialtimemachine.com")!)
                Link("Visit Website", destination: URL(string: "https://financialtimemachine.com")!)
            }
            
            Section(header: Text("FAQ")) {
                NavigationLink(destination: FAQView()) {
                    Text("Frequently Asked Questions")
                }
            }
        }
        .navigationTitle("Support")
    }
}

struct FAQView: View {
    var body: some View {
        List {
            Section(header: Text("General")) {
                FAQItem(question: "How do I add a new financial goal?", answer: "Go to the Dashboard and tap the 'Add Goal' button. Enter the goal details and save.")
                FAQItem(question: "How accurate are the projections?", answer: "Projections are based on the data you provide and historical market trends. They are estimates, not guarantees.")
            }
            
            Section(header: Text("Data & Privacy")) {
                FAQItem(question: "Is my data secure?", answer: "Yes, all data is stored locally on your device and protected with encryption.")
                FAQItem(question: "Can I export my data?", answer: "Yes, you can export your data from the Settings menu.")
            }
        }
        .navigationTitle("FAQ")
    }
}

struct FAQItem: View {
    let question: String
    let answer: String
    
    @State private var isExpanded = false
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                Text(answer)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            },
            label: {
                Text(question)
                    .foregroundColor(.white)
            }
        )
    }
}

struct FeedbackView: View {
    @State private var feedback = ""
    @State private var showingAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Your Feedback")) {
                TextEditor(text: $feedback)
                    .frame(height: 200)
            }
            
            Section {
                Button(action: {
                    // Submit feedback
                    showingAlert = true
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.green)
                }
            }
        }
        .navigationTitle("Feedback")
        .alert("Thank You", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your feedback has been submitted successfully.")
        }
    }
} 