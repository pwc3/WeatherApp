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
        TitleSubtitleRow(title: "Forecast office", subtitle: point.forecastOfficeId)
        TitleSubtitleRow(title: "Grid ID", subtitle: point.gridId)
        TitleSubtitleRow(title: "Grid X", subtitle: point.gridX.description)
        TitleSubtitleRow(title: "Grid Y", subtitle: point.gridY.description)
        TitleSubtitleRow(title: "Grid Y", subtitle: point.radarStation)
    }
}

struct PointMetadataView_Previews: PreviewProvider {
    static var previews: some View {
        // PointMetadataView()
        Text("TBD")
    }
}
