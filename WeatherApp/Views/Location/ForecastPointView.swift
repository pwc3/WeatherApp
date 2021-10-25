//
//  ForecastPointView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import SwiftUI
import WeatherAPI

struct ForecastPointView: View {

    private struct Row: View {
        var title: String
        var value: String

        var body: some View {
            VStack(alignment: .leading) {
                Text(title).font(.caption)
                Text(value).font(.body)
            }
        }
    }

    var point: Feature<Point>

    var body: some View {
        Row(title: "Forecast office", value: point.properties.forecastOfficeId)
        Row(title: "Grid ID", value: point.properties.gridId)
        Row(title: "Grid X", value: point.properties.gridX.description)
        Row(title: "Grid Y", value: point.properties.gridY.description)
        Row(title: "Grid Y", value: point.properties.radarStation)
    }
}

import SampleWeatherData

struct ForecastPointView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ForecastPointView(point: SampleData.point)
        }
    }
}
