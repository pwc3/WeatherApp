//
//  ForecastProvider.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/25/21.
//

import Foundation
import WeatherAPI

struct ForecastProvider: AsyncViewProvider {

    var service: WeatherService

    var location: Location

    var type: ForecastType

    func run() async throws -> Feature<GridpointForecast> {
        try await type.fetchForecast(for: location, using: service)
    }

    func createView(with response: Feature<GridpointForecast>) -> ForecastView {
        ForecastView(location: location, forecast: response, type: type)
    }
}
