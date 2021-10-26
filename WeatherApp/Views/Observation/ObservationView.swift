//
//  ObservationView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import SwiftUI
import WeatherAPI

struct ObservationView: View {

    @EnvironmentObject var environment: Environment

    var station: Feature<ObservationStation>

    var observation: Feature<Observation>

    var body: some View {
        List {
            Section {
                Text(station.properties.name)
                    .font(.body)

                OptionalRow("Elevation", elevation)
                OptionalRow("Timestamp", timestamp)
            }

            Section("Temperature") {
                OptionalRow("Temperature", temperature)
                OptionalRow("Dew point", dewPoint)
                OptionalRow("Min. temp. (last 24 hrs.)", minTemp)
                OptionalRow("Max. temp. (last 24 hrs.)", maxTemp)
                OptionalRow("Relative humidity", relativeHumidity)
                OptionalRow("Wind chill", windChill)
                OptionalRow("Heat index", heatIndex)

                if noValues(temperature, dewPoint, minTemp, maxTemp, relativeHumidity, windChill, heatIndex) {
                    Text("No data").font(.body)
                }
            }

            Section("Wind") {
                OptionalRow("Wind direction", windDirection)
                OptionalRow("Wind speed", windSpeed)
                OptionalRow("Wind gust", windGust)

                if noValues(windDirection, windSpeed, windGust) {
                    Text("No data").font(.body)
                }
            }

            Section("Pressure") {
                OptionalRow("Barometric pressure", barometricPressure)
                OptionalRow("Sea level pressure", seaLevelPressure)

                if noValues(barometricPressure, seaLevelPressure) {
                    Text("No data").font(.body)
                }
            }

            Section("Precipitation") {
                OptionalRow("Last hour", precipitationLastHour)
                OptionalRow("Last 3 hours", precipitationLast3Hours)
                OptionalRow("Last 6 hours", precipitationLast6Hours)

                if noValues(precipitationLastHour, precipitationLast3Hours, precipitationLast6Hours) {
                    Text("None").font(.body)
                }
            }

            Section("Clouds") {
                OptionalRow("Visibility", visibility)

                ForEach(Array(observation.properties.cloudLayers.enumerated()), id: \.0) { (_, layer) in
                    VStack(alignment: .leading) {
                        Text("Cloud layer").font(.caption)
                        Text(format(layer)).font(.body)
                    }
                }

                if observation.properties.cloudLayers.isEmpty && noValues(visibility) {
                    Text("No data").font(.body)
                }
            }
        }
    }

    private func noValues(_ elements: String?...) -> Bool {
        return elements.compactMap({ $0 }).isEmpty
    }

    private var elevation: String? {
        try? station.properties.elevation.length?.formatted()
    }

    private var timestamp: String? {
        Formatters.timestamp.string(from: observation.properties.timestamp)
    }

    private var temperature: String? {
        try? observation.properties.temperature.temperature?.formatted()
    }

    private var dewPoint: String? {
        try? observation.properties.dewpoint.temperature?.formatted()
    }

    private var minTemp: String? {
        try? observation.properties.minTemperatureLast24Hours.temperature?.formatted()
    }

    private var maxTemp: String? {
        try? observation.properties.maxTemperatureLast24Hours.temperature?.formatted()
    }

    private var relativeHumidity: String? {
        try? observation.properties.relativeHumidity.percent.map {
            String(format: "%.0f%%", $0)
        }
    }

    private var windChill: String? {
        try? observation.properties.windChill.temperature?.formatted()
    }

    private var heatIndex: String? {
        try? observation.properties.heatIndex.temperature?.formatted()
    }

    private var windSpeed: String? {
        try? observation.properties.windSpeed.speed?.formatted()
    }

    private var windGust: String? {
        try? observation.properties.windGust.speed?.formatted()
    }

    private var precipitationLastHour: String? {
        try? observation.properties.precipitationLastHour?.length?.formatted()
    }

    private var precipitationLast3Hours: String? {
        try? observation.properties.precipitationLast3Hours?.length?.formatted()
    }

    private var precipitationLast6Hours: String? {
        try? observation.properties.precipitationLast6Hours?.length?.formatted()
    }

    private var windDirection: String? {
        try? observation.properties.windDirection.angle.map {
            String(format: "%.0f°", $0.converted(to: .degrees).value)
        }
    }

    private var barometricPressure: String? {
        try? observation.properties.barometricPressure.pressure.map {
            return $0.converted(to: .millibars).formatted()
        }
    }

    private var seaLevelPressure: String? {
        try? observation.properties.seaLevelPressure.pressure.map {
            return $0.converted(to: .millibars).formatted()
        }
    }

    private var visibility: String? {
        try? observation.properties.visibility.length?.formatted()
    }

    private func format(_ layer: CloudLayer) -> String {
        return [
            layer.amount.rawValue,
            base(for: layer)
        ]
        .compactMap({ $0 })
        .joined(separator: " at ")
    }

    private func base(for layer: CloudLayer) -> String? {
        (try? layer.base.length?.converted(to: .feet).value).map {
            String(format: "%.0f ft", $0)
        }
    }
}

import SampleWeatherData

struct ObservationView_Previews: PreviewProvider {
    static var previews: some View {
        ObservationView(station: SampleData.observationStations.features[0],
                        observation: SampleData.observation)
    }
}
