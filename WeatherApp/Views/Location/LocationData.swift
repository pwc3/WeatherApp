//
//  LocationData.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import SwiftUI
import WeatherAPI

struct LocationData: View {

    enum LoadState {
        case loading
        case finished(Result<Point, Error>)
    }

    @EnvironmentObject var environment: Environment

    @State private var state: LoadState = .loading

    var location: Location

    var body: some View {
        switch state {
        case .loading:
            LoadingView()
                .onAppear {
                    Task {
                        self.state = .finished(await self.fetchPoint())
                    }
                }
                .navigationTitle(location.name)

        case .finished(let result):
            switch result {
            case .success(let point):
                List {
                    Section {
                        LocationDataRow(name: "Forecast office", value: point.forecastOfficeId)
                        LocationDataRow(name: "Grid ID", value: point.gridId)
                        LocationDataRow(name: "Grid X", value: point.gridX.description)
                        LocationDataRow(name: "Grid Y", value: point.gridY.description)
                        LocationDataRow(name: "Grid Y", value: point.radarStation)
                    }

                    Section {
                        
                    }
                }
                .navigationTitle(location.name)

            case .failure(let error):
                ErrorView(error: error)
            }
        }
    }

    private func fetchPoint() async -> Result<Point, Error> {
        await Result {
            try await environment.weatherService.points(
                latitude: location.latitude,
                longitude: location.longitude).properties
        }
    }
}

struct LocationData_Previews: PreviewProvider {
    static var previews: some View {
        LocationData(location: Location.boston)
            .environmentObject(Environment())
    }
}
