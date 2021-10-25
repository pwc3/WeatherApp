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

    var point: Feature<Point>

    var observationStations: FeatureCollection<ObservationStation>
}

// MARK: - API access

extension Location {
    static func fetch(using service: WeatherService, for place: Place) async throws -> Location {
        let pointRequest = PointRequest(latitude: place.latitude, longitude: place.longitude)
        let point = try await service.perform(request: pointRequest)

        let stationsRequest = StationsRequest(for: point)
        let stations = try await service.perform(request: stationsRequest)

        return Location(id: UUID(), place: place, point: point, observationStations: stations)
    }
}
