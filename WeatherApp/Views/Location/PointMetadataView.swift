//
//  PointMetadataView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import SwiftUI
import WeatherAPI

struct PointMetadataView: View {
    var point: Point

    var body: some View {
        LocationDataRow(name: "Forecast office", value: point.forecastOfficeId)
        LocationDataRow(name: "Grid ID", value: point.gridId)
        LocationDataRow(name: "Grid X", value: point.gridX.description)
        LocationDataRow(name: "Grid Y", value: point.gridY.description)
        LocationDataRow(name: "Grid Y", value: point.radarStation)
    }
}

struct PointMetadataView_Previews: PreviewProvider {
    static var previews: some View {
        // PointMetadataView()
        Text("TBD")
    }
}
