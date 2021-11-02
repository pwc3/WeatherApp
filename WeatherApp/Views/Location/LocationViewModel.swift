//
//  LocationViewModel.swift
//  WeatherApp
//
//  Created by Paul Calnan on 11/1/21.
//

import Foundation
import SwiftUI
import WeatherAPI

class LocationViewModel: AsyncViewModel<Location> {

    let place: Place

    init(place: Place) {
        self.place = place

        super.init {
            try await Location.fetch(using: $0.weatherService, for: place)
        }
    }
}
