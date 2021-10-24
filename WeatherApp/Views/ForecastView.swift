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

    private struct Row: View {
        var title: String
        var value: String

        init(_ title: String, _ value: () throws -> String?) {
            self.title = title
            do {
                self.value = try value() ?? "(n/a)"
            }
            catch {
                self.value = "(error)"
            }
        }

        var body: some View {
            VStack(alignment: .leading) {
                Text(title).font(.caption)
                Text(value).font(.body)
            }
        }
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
                            Text(period.shortForecast)
                                .font(.body)

                            if showDetailedForecast {
                                Text(period.detailedForecast)
                                    .font(.body)
                            }

                            if showStartAndEndTimes {
                                Row("Start time") { period.startTime.description }
                                Row("End time") { period.endTime.description }
                                Row("Is daytime?") { period.isDaytime ? "Yes" : "No"}
                            }

                            Row("Temperature") { String(format: "%d°%@", period.temperature, period.temperatureUnit) }
                            Row("Temperature trend") { period.temperatureTrend?.rawValue.capitalized ?? "(n/a)" }
                            Row("Wind speed") { period.windSpeed }
                            Row("Wind gust") { period.windGust }
                            Row("Wind direction") { period.windDirection.rawValue }
                        }
                    }
                }

            case .failed(let error):
                ErrorView(error: error)
            }
        }
        .navigationTitle(type.description)
    }

    private let sectionTitleTimeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "h a"
        df.locale = Locale(identifier: "en_US_POSIX")

        return df
    }()

    private func sectionTitle(for period: GridpointForecastPeriod) -> String {
        switch type {
        case .sevenDay:
            return period.name

        case .hourly:
            return sectionTitleTimeFormatter.string(from: period.startTime)
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
