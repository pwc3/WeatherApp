//
//  ObservationStationListView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import SwiftUI
import WeatherAPI

struct ObservationStationListView: View {
    var observationStations: FeatureCollection<ObservationStation>

    var body: some View {
        ForEach(observationStations.features, id: \.properties.stationIdentifier) {
            LocationDataRow(name: $0.properties.stationIdentifier, value: $0.properties.name)
        }
    }
}

struct ObservationStationListView_Previews: PreviewProvider {
    static var previews: some View {
        // ObservationStationListView()
        Text("TBD")
    }
}
