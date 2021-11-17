//
//  ForecastView.swift
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

import SwiftUI
import WeatherAPI

struct ForecastView: View {

    @EnvironmentObject var environment: Environment

    @ObservedObject var viewModel: ForecastViewModel

    var body: some View {
        List {
            switch viewModel.state {
            case .loading:
                LoadingView()
                // you use Swift 5 concurrency for the model, so it would make more
                // sense to use the matching SwiftUI task API here as well instead of
                // using .onAppear()
                    .onAppear {
                        viewModel.load(environment)
                    }

            case .failure(let error):
                ErrorView(error: error, onRetry: { viewModel.load(environment) })

            case .success(let forecast):
                ForEach(forecast.properties.periods, id: \.number) { period in
                    section(for: period)
                }
            }
        }
    }

    private func section(for period: GridpointForecastPeriod) -> some View {
        Section(sectionTitle(for: period)) {
            if showDetailedForecast {
                DetailedForecastView(period: period)
            }
            else {
                Text(period.shortForecast).font(.body)
            }

            OptionalRow("Temperature", String(format: "%d°%@", period.temperature, period.temperatureUnit))
            OptionalRow("Temperature trend", period.temperatureTrend?.rawValue.capitalized)
            OptionalRow("Wind speed", period.windSpeed)
            OptionalRow("Wind gust", period.windGust)
            OptionalRow("Wind direction", period.windDirection.rawValue)
        }
    }

    private func sectionTitle(for period: GridpointForecastPeriod) -> String {
        switch viewModel.forecastType {
        case .sevenDay:
            return period.name

        case .hourly:
            return Formatters.hour.string(from: period.startTime)
        }
    }

    private var showDetailedForecast: Bool {
        return viewModel.forecastType == .sevenDay
    }
}

import SampleWeatherData

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForecastView(viewModel: .previewHourlyForecast)
            ForecastView(viewModel: .previewSevenDayForecast)
        }
        .environmentObject(Environment())
    }
}

