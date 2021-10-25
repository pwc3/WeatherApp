//
//  DetailedForecastView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import SwiftUI
import WeatherAPI

struct DetailedForecastView: View {
    var period: GridpointForecastPeriod

    @State private var showDetailedForecast = false

    var body: some View {
        ExpandableSectionToggle(title: period.shortForecast, isExpanded: $showDetailedForecast)
        if showDetailedForecast {
            Text(period.detailedForecast).font(.body)
        }
    }
}

struct DetailedForecastView_Previews: PreviewProvider {
    static var previews: some View {
        Text("TBD")
    }
}
