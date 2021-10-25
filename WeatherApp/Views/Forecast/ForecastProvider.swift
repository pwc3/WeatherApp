//
//  ForecastProvider.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/25/21.
//

import Foundation
import WeatherAPI
import SwiftUI

struct ForecastProvider: AsyncViewProvider {

    var service: WeatherService

    var location: Location

    var type: ForecastType

    func run() async throws -> GridpointForecast {
        try await type.fetchForecast(for: location, using: service)
    }

    func createView(with response: GridpointForecast) -> ForecastView {
        ForecastView(location: location, forecast: response, type: type)
    }
}
