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

    var observationStations: FeatureCollection<ObservationStation>
}

extension Location {

    static func fetch(using service: WeatherService, for place: Place) async throws -> Location {
        let point = try await service.point(latitude: place.latitude, longitude: place.longitude).properties
        let stations = try await service.stations(for: point)
        return Location(id: UUID(), place: place, point: point, observationStations: stations)
    }
}
