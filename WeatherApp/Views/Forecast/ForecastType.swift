//
//  ForecastType.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/25/21.
//

import Foundation
import WeatherAPI

enum ForecastType {
    case sevenDay
    case hourly

    var description: String {
        switch self {
        case .sevenDay:
            return "Seven-day forecast"

        case .hourly:
            return "Hourly forecast"
        }
    }

    func fetchForecast(for location: Location, using service: WeatherService) async throws -> Feature<GridpointForecast> {
        let hourly: Bool
        switch self {
        case .hourly:
            hourly = true

        case .sevenDay:
            hourly = false
        }

        return try await service.perform(request: ForecastRequest(for: location.point, hourly: hourly))
    }
}
