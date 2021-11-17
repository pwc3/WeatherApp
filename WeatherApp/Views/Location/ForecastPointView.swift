//
//  ForecastPointView.swift
//  WeatherApp
//
//  Copyright (c) 2021 Rocket Insights, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

import SwiftUI
import WeatherAPI

// This view also heavily relies on being inside a List, so the the expand / collapse animation
// doesn't slide down / up as it should.
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

