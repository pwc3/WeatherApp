//
//  Place.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import CoreLocation
import Foundation

struct Place: Codable, Hashable, Identifiable {

    var id: Int

    var name: String

    var latitude: Double

    var longitude: Double
}
