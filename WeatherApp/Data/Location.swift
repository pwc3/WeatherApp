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

// MARK: - Fetch from API

extension Location {
    static func fetch(using service: WeatherService, for place: Place) async throws -> Location {
        let point = try await service.point(latitude: place.latitude, longitude: place.longitude).properties
        let stations = try await service.stations(for: point).features.map { $0.properties }
        return Location(id: UUID(), place: place, point: point, observationStations: stations)
    }
}

// MARK: - API Endpoints

extension Location {
    func forecast(using service: WeatherService) async throws -> GridpointForecast {
        try await service.forecast(for: point).properties
    }

    func hourlyForecast(using service: WeatherService) async throws -> GridpointForecast {
        try await service.hourlyForecast(for: point).properties
    }
}

extension ObservationStation {
    func latestObservation(using service: WeatherService) async throws -> Observation {
        try await service.latestObservation(for: self).properties
    }
}
