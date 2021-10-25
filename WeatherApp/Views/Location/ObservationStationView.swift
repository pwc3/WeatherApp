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

    var observationStations: [ObservationStation]

    var body: some View {
        ForEach(observationStations, id: \.stationIdentifier) { station in
            NavigationLink(destination: asyncObservationView(for: station)) {
                VStack(alignment: .leading) {
                    Text(station.stationIdentifier).font(.body)
                    Text(station.name).font(.caption)
                }
            }
        }
    }

    private func asyncObservationView(for station: ObservationStation) -> some View {
        AsyncView(title: station.stationIdentifier,
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
