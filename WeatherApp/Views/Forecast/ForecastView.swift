//
//  ForecastView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import SwiftUI
import WeatherAPI

struct ForecastView: View {

    @EnvironmentObject var environment: Environment

    var location: Location

    var forecast: Feature<GridpointForecast>

    var type: ForecastType

    var body: some View {
        List {
            ForEach(forecast.properties.periods, id: \.number) { period in
                Section(sectionTitle(for: period)) {
                    if showDetailedForecast {
                        DetailedForecastView(period: period)
                    }
                    else {
                        Text(period.shortForecast).font(.body)
                    }

                    if showStartAndEndTimes {
                        OptionalRow("Start time", Formatters.timestamp.string(for: period.startTime.description))
                        OptionalRow("End time", Formatters.timestamp.string(for: period.endTime.description))
                    }

                    OptionalRow("Temperature", String(format: "%d°%@", period.temperature, period.temperatureUnit))
                    OptionalRow("Temperature trend", period.temperatureTrend?.rawValue.capitalized)
                    OptionalRow("Wind speed", period.windSpeed)
                    OptionalRow("Wind gust", period.windGust)
                    OptionalRow("Wind direction", period.windDirection.rawValue)
                }
            }
        }
    }

    private func sectionTitle(for period: GridpointForecastPeriod) -> String {
        switch type {
        case .sevenDay:
            return period.name

        case .hourly:
            return Formatters.hour.string(from: period.startTime)
        }
    }

    private var showDetailedForecast: Bool {
        return type == .sevenDay
    }

    private var showStartAndEndTimes: Bool {
        return type == .sevenDay
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        Text("TBD")
    }
}
