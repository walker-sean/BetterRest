//
//  ContentView.swift
//  BetterRest
//
//  Created by Sean Walker on 8/13/23.
//

import CoreML
import SwiftUI

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    private var reccommendedBedtime: Date? {
        var reccommendation: Date = Date.now
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            reccommendation = wakeUp - prediction.actualSleep
        } catch {
                alertTitle = "Error"
                alertMessage = "Sorry, there was a problem calculating your bedtime"
            showingAlert = true
        }
        return reccommendation
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                Section {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                Section {
                    Text("Daily coffee intake")
                        .font(.headline)
                    Picker("Daily coffee intake", selection: $coffeeAmount) {
                        ForEach(1..<21) { number in
                            Text("\(number) \(number == 1 ? "cup" : "cups")").tag(number)
                        }
                    }
                    .labelsHidden()
                }
                Section {
                    Text("Reccommended Bedtime")
                        .font(.headline)
                    Text(reccommendedBedtime?.formatted(date: .omitted, time: .shortened) ?? "")
                }
            }
            .navigationTitle("BetterRest")
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
