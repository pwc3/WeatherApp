//
//  LocationView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
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
