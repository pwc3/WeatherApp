//
//  ObservationViewModel.swift
//  WeatherApp
//
//  Created by Paul Calnan on 11/2/21.
//

import Foundation
import SampleWeatherData
import WeatherAPI

class ObservationViewModel: AsyncViewModel<Feature<Observation>> {

    let station: Feature<ObservationStation>

    init(station: Feature<ObservationStation>) {
        self.station = station

        super.init {
            try await $0.weatherService.perform(request: LatestObservationRequest(stationId: station.properties.stationIdentifier))
        }
    }

    // MARK: - Station Data

    var stationName: String {
        station.properties.name
    }

    var elevation: String? {
        try? station.properties.elevation.length?.formatted()
    }

    var timestamp: String? {
        (value?.properties.timestamp).map {
            Formatters.timestamp.string(from: $0)
        }
    }

    // MARK: - Temperature

    var hasTemperatureData: Bool {
        return anyNonNil(temperature, dewPoint, minTemp, maxTemp, relativeHumidity, windChill, heatIndex)
    }

    var temperature: String? {
        try? value?.properties.temperature.temperature?.formatted()
    }

    var dewPoint: String? {
        try? value?.properties.dewpoint.temperature?.formatted()
    }

    var minTemp: String? {
        try? value?.properties.minTemperatureLast24Hours.temperature?.formatted()
    }

    var maxTemp: String? {
        try? value?.properties.maxTemperatureLast24Hours.temperature?.formatted()
    }

    var relativeHumidity: String? {
        try? value?.properties.relativeHumidity.percent.map {
            String(format: "%.0f%%", $0)
        }
    }

    var windChill: String? {
        try? value?.properties.windChill.temperature?.formatted()
    }

    var heatIndex: String? {
        try? value?.properties.heatIndex.temperature?.formatted()
    }

    // MARK: - Wind

    var hasWindData: Bool {
        return anyNonNil(windSpeed, windDirection, windGust)
    }

    var windSpeed: String? {
        try? value?.properties.windSpeed.speed?.formatted()
    }

    var windGust: String? {
        try? value?.properties.windGust.speed?.formatted()
    }

    var windDirection: String? {
        try? value?.properties.windDirection.angle.map {
            String(format: "%.0f°", $0.converted(to: .degrees).value)
        }
    }

    // MARK: - Pressure

    var hasPressureData: Bool {
        return anyNonNil(barometricPressure, seaLevelPressure)
    }

    var barometricPressure: String? {
        try? value?.properties.barometricPressure.pressure.map {
            return $0.converted(to: .millibars).formatted()
        }
    }

    var seaLevelPressure: String? {
        try? value?.properties.seaLevelPressure.pressure.map {
            return $0.converted(to: .millibars).formatted()
        }
    }

    // MARK: - Precipitation

    var hasPrecipitationData: Bool {
        return anyNonNil(precipitationLastHour, precipitationLast3Hours, precipitationLast6Hours)
    }

    var precipitationLastHour: String? {
        try? value?.properties.precipitationLastHour?.length?.formatted()
    }

    var precipitationLast3Hours: String? {
        try? value?.properties.precipitationLast3Hours?.length?.formatted()
    }

    var precipitationLast6Hours: String? {
        try? value?.properties.precipitationLast6Hours?.length?.formatted()
    }

    // MARK: - Clouds

    var hasCloudData: Bool {
        return !cloudLayers.isEmpty && visibility != nil
    }

    private var cloudLayers: [CloudLayer] {
        value?.properties.cloudLayers ?? []
    }

    var formattedCloudLayers: [String] {
        cloudLayers.map {
            format($0)
        }
    }

    var visibility: String? {
        try? value?.properties.visibility.length?.formatted()
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

extension ObservationViewModel {

    static var preview: ObservationViewModel {
        preview(station: SampleData.observationStations.features[0],
                observation: SampleData.observation)
    }

    static func preview(station: Feature<ObservationStation>, observation: Feature<Observation>) -> ObservationViewModel {
        let viewModel = ObservationViewModel(station: station)
        viewModel.state = .success(observation)
        return viewModel
    }
}
