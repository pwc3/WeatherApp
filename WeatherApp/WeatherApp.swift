//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import SwiftUI
import WeatherAPI

@main
struct WeatherApp: App {

    @StateObject private var environment = Environment()

    var body: some Scene {
        WindowGroup {
            ContentView(places: Place.samples)
                .environmentObject(environment)
        }
    }
}
