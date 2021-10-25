//
//  Location+Sample.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import Foundation
import WeatherAPI
import SampleWeatherData

extension Location {

    static var sample: Location {
        Location(id: UUID(), place: Place.samples[0], point: SampleData.point, observationStations: SampleData.observationStations)
    }
}
