//
//  ObservationStationView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import SwiftUI
import WeatherAPI

struct ObservationStationView: View {

    @EnvironmentObject var environment: Environment

    var observationStations: FeatureCollection<ObservationStation>

    var body: some View {
        ForEach(observationStations.features, id: \.properties.stationIdentifier) { station in
            NavigationLink(destination: asyncObservationView(for: station)) {
                VStack(alignment: .leading) {
                    Text(station.properties.stationIdentifier).font(.body)
                    Text(station.properties.name).font(.caption)
                }
            }
        }
    }

    private func asyncObservationView(for station: Feature<ObservationStation>) -> some View {
        AsyncView(title: station.properties.stationIdentifier,
                  provider: ObservationProvider(service: environment.weatherService,
                                                station: station))
    }
}

struct ObservationStationSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Text("TBD")
        }
    }
}
