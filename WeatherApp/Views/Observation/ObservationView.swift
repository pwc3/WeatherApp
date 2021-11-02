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
            Section {
                Text(viewModel.stationName)
                    .font(.body)

                OptionalRow("Elevation", viewModel.elevation)
                OptionalRow("Timestamp", viewModel.timestamp)
            }

            Section("Temperature") {
                if viewModel.hasTemperatureData {
                    OptionalRow("Temperature", viewModel.temperature)
                    OptionalRow("Dew point", viewModel.dewPoint)
                    OptionalRow("Min. temp. (last 24 hrs.)", viewModel.minTemp)
                    OptionalRow("Max. temp. (last 24 hrs.)", viewModel.maxTemp)
                    OptionalRow("Relative humidity", viewModel.relativeHumidity)
                    OptionalRow("Wind chill", viewModel.windChill)
                    OptionalRow("Heat index", viewModel.heatIndex)
                }
                else {
                    Text("No data").font(.body)
                }
            }

            Section("Wind") {
                if viewModel.hasWindData {
                    OptionalRow("Wind direction", viewModel.windDirection)
                    OptionalRow("Wind speed", viewModel.windSpeed)
                    OptionalRow("Wind gust", viewModel.windGust)
                }
                else {
                    Text("No data").font(.body)
                }
            }

            Section("Pressure") {
                if viewModel.hasPressureData {
                    OptionalRow("Barometric pressure", viewModel.barometricPressure)
                    OptionalRow("Sea level pressure", viewModel.seaLevelPressure)
                }
                else {
                    Text("No data").font(.body)
                }
            }

            Section("Precipitation") {
                if viewModel.hasPrecipitationData {
                    OptionalRow("Last hour", viewModel.precipitationLastHour)
                    OptionalRow("Last 3 hours", viewModel.precipitationLast3Hours)
                    OptionalRow("Last 6 hours", viewModel.precipitationLast6Hours)
                }
                else {
                    Text("None").font(.body)
                }
            }

            Section("Clouds") {
                if viewModel.hasCloudData {
                    OptionalRow("Visibility", viewModel.visibility)

                    ForEach(Array(viewModel.formattedCloudLayers.enumerated()), id: \.0) { (_, layer) in
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


}

import SampleWeatherData

struct ObservationView_Previews: PreviewProvider {
    static var previews: some View {
        ObservationView(viewModel: ObservationViewModel.preview)
    }
}

