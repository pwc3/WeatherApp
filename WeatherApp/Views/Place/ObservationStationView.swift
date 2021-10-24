//
//  ObservationStationView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import SwiftUI
import WeatherAPI

struct ObservationStationView: View {
    var observationStations: FeatureCollection<ObservationStation>

    var body: some View {
        ForEach(observationStations.features, id: \.properties.stationIdentifier) {
            TitleSubtitleRow(title: $0.properties.stationIdentifier, subtitle: $0.properties.name)
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
