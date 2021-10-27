//
//  LocationView.swift
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

struct LocationView: View {

    @EnvironmentObject var environment: Environment

    @State private var isPointMetadataExpanded = false

    @State private var isObservationStationListExpanded = false

    var location: Location

    var body: some View {
        List {
            Section {
                ExpandableSectionToggle(title: "Forecast point", isExpanded: $isPointMetadataExpanded)
                if isPointMetadataExpanded {
                    ForecastPointView(point: location.point)
                }
            }

            Section(footer: Text("Select a station to see current conditions at that location")) {
                NavigationLink(destination: ObservationStationsMapView(stations: location.observationStations)) {
                    Text("Station map")
                }

                ExpandableSectionToggle(title: "Observation stations", isExpanded: $isObservationStationListExpanded)
                if isObservationStationListExpanded {
                    ObservationStationView(observationStations: location.observationStations)
                }
            }

            Section {
                NavigationLink(destination: asyncForecastView(for: location, type: .hourly)) {
                    Text("Hourly forecast")
                }

                NavigationLink(destination: asyncForecastView(for: location, type: .sevenDay)) {
                    Text("Seven-day forecast")
                }
            }
        }
    }

    private func asyncForecastView(for location: Location, type: ForecastType) -> some View {
        AsyncView(title: type.description,
                  provider: ForecastProvider(service: environment.weatherService,
                                             location: location,
                                             type: type))
    }
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(location: Location.sample)
            .environmentObject(Environment())
    }
}

