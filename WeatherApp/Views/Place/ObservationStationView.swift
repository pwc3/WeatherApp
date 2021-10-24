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
        ForEach(observationStations, id: \.stationIdentifier) {
            TitleSubtitleRow(title: $0.stationIdentifier, subtitle: $0.name)
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
