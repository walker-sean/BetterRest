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
        DatePicker("Please select a date: ", selection: $wakeUp, in: ...Date.now)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
