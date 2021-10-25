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

    var station: Feature<ObservationStation>

    func run() async throws -> Feature<Observation> {
        try await service.perform(request: LatestObservationRequest(stationId: station.properties.stationIdentifier))
    }

    func createView(with response: Feature<Observation>) -> ObservationView {
        ObservationView(station: station, observation: response)
    }
}
