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
        List {
            ForEach(observationStations.features, id: \.properties.stationIdentifier) {
                TitleSubtitleRow(title: $0.properties.stationIdentifier, subtitle: $0.properties.name)
            }
        }
    }
}

struct ObservationStationListView_Previews: PreviewProvider {
    static var previews: some View {
        ObservationStationListView(observationStations: SampleData.observationStations)
    }
}
