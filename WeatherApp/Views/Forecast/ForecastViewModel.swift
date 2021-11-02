//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by Paul Calnan on 11/2/21.
//

import Foundation
import WeatherAPI
import SampleWeatherData

class ForecastViewModel: AsyncViewModel<Feature<GridpointForecast>> {

    let location: Location

    let forecastType: ForecastType

    init(location: Location, forecastType: ForecastType) {
        self.location = location
        self.forecastType = forecastType

        super.init {
            try await forecastType.fetchForecast(for: location, using: $0.weatherService)
        }
    }
}

extension ForecastViewModel {

    static var previewHourlyForecast: ForecastViewModel {
        preview(location: Location.sample, forecastType: .hourly, result: SampleData.hourlyGridpointForecast)
    }

    static var previewSevenDayForecast: ForecastViewModel {
        preview(location: Location.sample, forecastType: .sevenDay, result: SampleData.sevenDayGridpointForecast)
    }

    static func preview(location: Location, forecastType: ForecastType, result: Feature<GridpointForecast>) -> ForecastViewModel {
        let viewModel = ForecastViewModel(location: location, forecastType: forecastType)
        viewModel.state = .success(result)
        return viewModel
    }
}
