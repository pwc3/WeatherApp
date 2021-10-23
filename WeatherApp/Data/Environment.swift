//
//  Environment.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import Foundation
import WeatherAPI

class Environment: ObservableObject {

    let weatherService: WeatherService

    init() {
        weatherService = WeatherService.default
    }
}
