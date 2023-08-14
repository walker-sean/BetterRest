//
//  ContentView.swift
//  BetterRest
//
//  Created by Sean Walker on 8/13/23.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    
    var body: some View {
        VStack {
            DatePicker("Please select a date: ", selection: $wakeUp, in: ...Date.now)
            Text(wakeUp.formatted(date: .long , time: .shortened))
        }
    }
    
    func trivalExample() {
        var components = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
        let hour = components.hour ?? 0
        let minutes = components.minute ?? 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
