//
//  ObservationModelFormatter.swift
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

struct ObservationModelFormatter {
    var station: Feature<ObservationStation>

    var observation: Feature<Observation>

    // MARK: - General Data

    var stationName: String {
        station.properties.name
    }

    var elevation: String? {
        try? station.properties.elevation.length?.formatted()
    }

    var timestamp: String {
        Formatters.timestamp.string(from: observation.properties.timestamp)
    }

    // MARK: - Temperature

    var hasTemperatureData: Bool {
        return anyNonNil(temperature, dewPoint, minTemp, maxTemp, relativeHumidity, windChill, heatIndex)
    }

    var temperature: String? {
        try? observation.properties.temperature.temperature?.formatted()
    }

    var dewPoint: String? {
        try? observation.properties.dewpoint.temperature?.formatted()
    }

    var minTemp: String? {
        try? observation.properties.minTemperatureLast24Hours.temperature?.formatted()
    }

    var maxTemp: String? {
        try? observation.properties.maxTemperatureLast24Hours.temperature?.formatted()
    }

    var relativeHumidity: String? {
        try? observation.properties.relativeHumidity.percent.map {
            String(format: "%.0f%%", $0)
        }
    }

    var windChill: String? {
        try? observation.properties.windChill.temperature?.formatted()
    }

    var heatIndex: String? {
        try? observation.properties.heatIndex.temperature?.formatted()
    }

    // MARK: - Wind

    var hasWindData: Bool {
        return anyNonNil(windSpeed, windDirection, windGust)
    }

    var windSpeed: String? {
        try? observation.properties.windSpeed.speed?.formatted()
    }

    var windGust: String? {
        try? observation.properties.windGust.speed?.formatted()
    }

    var windDirection: String? {
        try? observation.properties.windDirection.angle.map {
            String(format: "%.0f°", $0.converted(to: .degrees).value)
        }
    }

    // MARK: - Pressure

    var hasPressureData: Bool {
        return anyNonNil(barometricPressure, seaLevelPressure)
    }

    var barometricPressure: String? {
        try? observation.properties.barometricPressure.pressure.map {
            return $0.converted(to: .millibars).formatted()
        }
    }

    var seaLevelPressure: String? {
        try? observation.properties.seaLevelPressure.pressure.map {
            return $0.converted(to: .millibars).formatted()
        }
    }

    // MARK: - Precipitation

    var hasPrecipitationData: Bool {
        return anyNonNil(precipitationLastHour, precipitationLast3Hours, precipitationLast6Hours)
    }

    var precipitationLastHour: String? {
        try? observation.properties.precipitationLastHour?.length?.formatted()
    }

    var precipitationLast3Hours: String? {
        try? observation.properties.precipitationLast3Hours?.length?.formatted()
    }

    var precipitationLast6Hours: String? {
        try? observation.properties.precipitationLast6Hours?.length?.formatted()
    }

    // MARK: - Clouds

    var hasCloudData: Bool {
        return !cloudLayers.isEmpty && visibility != nil
    }

    private var cloudLayers: [CloudLayer] {
        observation.properties.cloudLayers
    }

    var formattedCloudLayers: [String] {
        cloudLayers.map {
            format($0)
        }
    }

    var visibility: String? {
        try? observation.properties.visibility.length?.formatted()
    }

    // MARK: - Helpers

    private func anyNonNil(_ elements: String?...) -> Bool {
        return !elements.compactMap({ $0 }).isEmpty
    }

    private func format(_ layer: CloudLayer) -> String {
        return [
            layer.amount.rawValue,
            base(for: layer)
        ]
        .compactMap({ $0 })
        .joined(separator: " at ")
    }

    func base(for layer: CloudLayer) -> String? {
        (try? layer.base.length?.converted(to: .feet).value).map {
            String(format: "%.0f ft", $0)
        }
    }
}
