//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Copyright (c) 2021 Rocket Insights, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
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
