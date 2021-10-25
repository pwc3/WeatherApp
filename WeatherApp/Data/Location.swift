//
//  Location.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import Foundation
import WeatherAPI

struct Location: Identifiable {

    var id: UUID

    var place: Place

    var point: Point

    var observationStations: [ObservationStation]
}

// MARK: - API access

extension Location {
    static func fetch(using service: WeatherService, for place: Place) async throws -> Location {
        let pointRequest = PointRequest(latitude: place.latitude, longitude: place.longitude)
        let point = try await service.perform(request: pointRequest).properties

        let stationsRequest = StationsRequest(for: point)
        let stations = try await service.perform(request: stationsRequest).features.map { $0.properties }

        return Location(id: UUID(), place: place, point: point, observationStations: stations)
    }

    func forecast(using service: WeatherService, hourly: Bool) async throws -> GridpointForecast {
        try await service.perform(request: ForecastRequest(for: point, hourly: hourly)).properties
    }
}

extension ObservationStation {
    func latestObservation(using service: WeatherService) async throws -> Observation {
        try await service.perform(request: LatestObservationRequest(for: self)).properties
    }
}
