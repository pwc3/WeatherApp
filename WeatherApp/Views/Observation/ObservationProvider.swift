//
//  ObservationProvider.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/25/21.
//

import Foundation
import WeatherAPI

struct ObservationProvider: AsyncViewProvider {

    var service: WeatherService

    var station: ObservationStation

    func run() async throws -> Observation {
        try await station.latestObservation(using: service)
    }

    func createView(with response: Observation) -> ObservationView {
        ObservationView(station: station, observation: response)
    }
}
