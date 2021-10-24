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

    var point: Point

    var body: some View {
        Row(title: "Forecast office", value: point.forecastOfficeId)
        Row(title: "Grid ID", value: point.gridId)
        Row(title: "Grid X", value: point.gridX.description)
        Row(title: "Grid Y", value: point.gridY.description)
        Row(title: "Grid Y", value: point.radarStation)
    }
}

struct ForecastPointView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ForecastPointView(point: SampleData.point)
        }
    }
}
