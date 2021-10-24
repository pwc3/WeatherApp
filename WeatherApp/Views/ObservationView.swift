//
//  ObservationView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import SwiftUI
import WeatherAPI

struct ObservationView: View {

    private enum LoadState {
        case loading
        case successful(Observation)
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

            case .successful(let observation):
                List {
                    Section {
                        Row("Timestamp") { observation.timestamp }
                        Row("Message") { observation.rawMessage }
                    }

                    Section("Temperature") {
                        Row("Temperature") { try observation.temperature.temperature?.formatted() }
                        Row("Dew point") { try observation.dewpoint.temperature?.formatted() }
                        Row("Max. temp. (last 24 hrs.)") { try observation.maxTemperatureLast24Hours.temperature?.formatted() }
                        Row("Min. temp. (last 24 hrs.)") { try observation.minTemperatureLast24Hours.temperature?.formatted() }

                        Row("Relative humidity") { try observation.relativeHumidity.percent?.formatted() }
                        Row("Wind chill") { try observation.windChill.temperature?.formatted() }
                        Row("Heat index") { try observation.heatIndex.temperature?.formatted() }
                    }

                    Section("Wind") {
                        Row("Wind direction") { try observation.windDirection.angle?.formatted() }
                        Row("Wind speed") { try observation.windSpeed.speed?.formatted() }
                        Row("Wind gust") { try observation.windGust.speed?.formatted() }
                    }

                    Section("Pressure") {
                        Row("Barometric pressure") { try observation.barometricPressure.pressure?.formatted() }
                        Row("Sea level pressure") { try observation.seaLevelPressure.pressure?.formatted() }
                    }

                    Section("Precipitation") {
                        Row("Last hour") { try observation.precipitationLastHour.length?.formatted() }
                        Row("Last 3 hours") { try observation.precipitationLast3Hours.length?.formatted() }
                        Row("Last 6 hours") { try observation.precipitationLast6Hours.length?.formatted() }
                    }

                    Section("Clouds") {
                        Row("Visibility") { try observation.visibility.length?.formatted() }
                        ForEach(Array(observation.cloudLayers.enumerated()), id: \.0) { (_, layer) in
                            VStack(alignment: .leading) {
                                Text("Cloud layer").font(.caption)
                                Text(string(for: layer)).font(.body)
                            }
                        }
                    }
                }

            case .failed(let error):
                ErrorView(error: error)
            }
        }
        .navigationTitle("Current conditions")
    }

    private func string(for layer: CloudLayer) -> String {
        return [
            layer.amount.rawValue,
            base(for: layer)
        ]
        .compactMap({ $0 })
        .joined(separator: " at ")
    }

    private func base(for layer: CloudLayer) -> String? {
        return try? layer.base.length?.formatted()
    }

    private func fetch() async -> LoadState {
        do {
            return .successful(try await location.latestObservation(using: environment.weatherService))
        }
        catch {
            return .failed(error)
        }
    }
}

struct ObservationView_Previews: PreviewProvider {
    static var previews: some View {
        ObservationView(location: SampleData.location)
            .environmentObject(Environment())
    }
}
