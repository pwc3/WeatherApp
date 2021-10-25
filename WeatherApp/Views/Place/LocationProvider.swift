//
//  LocationProvider.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/25/21.
//

import Foundation
import WeatherAPI

struct LocationProvider: AsyncViewProvider {

    var service: WeatherService

    var place: Place

    func run() async throws -> Location {
        try await Location.fetch(using: service, for: place)
    }

    func createView(with response: Location) -> LocationView {
        LocationView(location: response)
    }
}
