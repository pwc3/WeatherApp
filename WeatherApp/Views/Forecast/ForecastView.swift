//
//  ForecastView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import SwiftUI
import WeatherAPI

struct ForecastView: View {

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

        fileprivate func fetchForecast(for location: Location, using service: WeatherService) async throws -> GridpointForecast {
            switch self {
            case .hourly:
                return try await service.hourlyForecast(for: location.point).properties

            case .sevenDay:
                return try await service.forecast(for: location.point).properties
            }
        }
    }

    private enum LoadState {
        case loading
        case successful(GridpointForecast)
        case failed(Error)
    }

    @EnvironmentObject var environment: Environment

    @State private var loadState: LoadState = .loading

    var location: Location

    var type: ForecastType

    var body: some View {
        Group {
            switch loadState {
            case .loading:
                ProgressView()
                    .onAppear {
                        Task {
                            self.loadState = await self.fetch()
                        }
                    }

            case .successful(let forecast):
                List {
                    ForEach(forecast.periods, id: \.number) { period in
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

            case .failed(let error):
                ErrorView(error: error)
            }
        }
        .navigationTitle(type.description)
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

    private func fetch() async -> LoadState {
        do {
            return .successful(try await type.fetchForecast(for: location, using: environment.weatherService))
        }
        catch {
            return .failed(error)
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView(location: SampleData.location, type: .hourly)
            .environmentObject(Environment())
    }
}
