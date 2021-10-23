//
//  Location.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import CoreLocation
import Foundation

struct Location: Codable, Hashable, Identifiable {

    var id = UUID()

    var name: String

    var latitude: Double

    var longitude: Double
}

extension Location {
    static let boston     = Location(name: "Boston, MA",      latitude: 42.360081, longitude: -71.058884)
    static let chicago    = Location(name: "Chicago, IL",     latitude: 41.878113, longitude: -87.629799)
    static let denver     = Location(name: "Denver, CO",      latitude: 39.739235, longitude: -104.990250)
    static let losAngeles = Location(name: "Los Angeles, CA", latitude: 34.052235, longitude: -118.243683)

    static let all = [boston, chicago, denver, losAngeles]
}
