//
//  ObservationView.swift
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

struct ObservationView: View {

    @EnvironmentObject var environment: Environment

    @ObservedObject var viewModel: ObservationViewModel

    var body: some View {
        List {
            switch viewModel.state {
            case .loading:
                LoadingView()
                    .onAppear {
                        viewModel.load(environment)
                    }

            case .failure(let error):
                ErrorView(error: error, onRetry: { viewModel.load(environment) })

            case .success(let model):
                Section {
                    Text(model.stationName)
                        .font(.body)

                    OptionalRow("Elevation", model.elevation)
                    OptionalRow("Timestamp", model.timestamp)
                }

                Section("Temperature") {
                    if model.hasTemperatureData {
                        OptionalRow("Temperature", model.temperature)
                        OptionalRow("Dew point", model.dewPoint)
                        OptionalRow("Min. temp. (last 24 hrs.)", model.minTemp)
                        OptionalRow("Max. temp. (last 24 hrs.)", model.maxTemp)
                        OptionalRow("Relative humidity", model.relativeHumidity)
                        OptionalRow("Wind chill", model.windChill)
                        OptionalRow("Heat index", model.heatIndex)
                    }
                    else {
                        Text("No data").font(.body)
                    }
                }

                Section("Wind") {
                    if model.hasWindData {
                        OptionalRow("Wind direction", model.windDirection)
                        OptionalRow("Wind speed", model.windSpeed)
                        OptionalRow("Wind gust", model.windGust)
                    }
                    else {
                        Text("No data").font(.body)
                    }
                }

                Section("Pressure") {
                    if model.hasPressureData {
                        OptionalRow("Barometric pressure", model.barometricPressure)
                        OptionalRow("Sea level pressure", model.seaLevelPressure)
                    }
                    else {
                        Text("No data").font(.body)
                    }
                }

                Section("Precipitation") {
                    if model.hasPrecipitationData {
                        OptionalRow("Last hour", model.precipitationLastHour)
                        OptionalRow("Last 3 hours", model.precipitationLast3Hours)
                        OptionalRow("Last 6 hours", model.precipitationLast6Hours)
                    }
                    else {
                        Text("None").font(.body)
                    }
                }

                Section("Clouds") {
                    if model.hasCloudData {
                        OptionalRow("Visibility", model.visibility)

                        ForEach(Array(model.formattedCloudLayers.enumerated()), id: \.0) { (_, layer) in
                            VStack(alignment: .leading) {
                                Text("Cloud layer").font(.caption)
                                Text(layer).font(.body)
                            }
                        }
                    }
                    else {
                        Text("No data").font(.body)
                    }
                }
            }
        }
        .navigationTitle(viewModel.stationIdentifier)
    }
}

import SampleWeatherData

struct ObservationView_Previews: PreviewProvider {
    static var previews: some View {
        ObservationView(viewModel: ObservationViewModel.preview)
    }
}

