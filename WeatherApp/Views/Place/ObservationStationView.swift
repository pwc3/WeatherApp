//
//  ObservationStationView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import SwiftUI
import WeatherAPI

struct ObservationStationView: View {
    var observationStations: [ObservationStation]

    var body: some View {
        ForEach(observationStations, id: \.stationIdentifier) { station in
            VStack(alignment: .leading) {
                Text(station.stationIdentifier).font(.body)
                Text(station.name).font(.caption)
            }
        }
    }
}

struct ObservationStationSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ObservationStationView(observationStations: SampleData.observationStations)
        }
    }
}
