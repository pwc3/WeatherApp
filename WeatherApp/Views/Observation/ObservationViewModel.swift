//
//  ObservationViewModel.swift
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
import SampleWeatherData
import WeatherAPI

class ObservationViewModel: AsyncViewModel<ObservationModelFormatter> {

    let station: Feature<ObservationStation>

    init(station: Feature<ObservationStation>) {
        self.station = station

        super.init {
            ObservationModelFormatter(station: station,
                             observation: try await $0.weatherService.perform(
                                request: LatestObservationRequest(stationId: station.properties.stationIdentifier)))
        }
    }

    var stationIdentifier: String {
        station.properties.stationIdentifier
    }
}

extension ObservationViewModel {

    static var preview: ObservationViewModel {
        preview(station: SampleData.observationStations.features[0],
                observation: SampleData.observation)
    }

    static func preview(station: Feature<ObservationStation>, observation: Feature<Observation>) -> ObservationViewModel {
        preview(model: ObservationModelFormatter(station: station, observation: observation))
    }

    static func preview(model: ObservationModelFormatter) -> ObservationViewModel {
        let viewModel = ObservationViewModel(station: model.station)
        viewModel.state = .success(model)
        return viewModel
    }
}
