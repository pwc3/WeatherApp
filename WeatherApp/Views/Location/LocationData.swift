//
//  LocationData.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import SwiftUI
import WeatherAPI

struct LocationData: View {

    private struct ModelData {
        var point: Point
        var station: FeatureCollection<ObservationStation>
    }

    private enum LoadState {
        case loading
        case finished(Result<ModelData, Error>)
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
                        self.state = .finished(await self.fetch())
                    }
                }
                .navigationTitle(location.name)

        case .finished(let result):
            switch result {
            case .success(let modelData):
                List {
                    Section(header: Text("Forecast point")) {
                        LocationDataRow(name: "Forecast office", value: modelData.point.forecastOfficeId)
                        LocationDataRow(name: "Grid ID", value: modelData.point.gridId)
                        LocationDataRow(name: "Grid X", value: modelData.point.gridX.description)
                        LocationDataRow(name: "Grid Y", value: modelData.point.gridY.description)
                        LocationDataRow(name: "Grid Y", value: modelData.point.radarStation)
                    }

                    Section(header: Text("Nearby observation stations")) {
                        ForEach(modelData.station.features, id: \.properties.stationIdentifier) {
                            LocationDataRow(name: $0.properties.stationIdentifier, value: $0.properties.name)
                        }
                    }
                }
                .navigationTitle(location.name)

            case .failure(let error):
                ErrorView(error: error)
            }
        }
    }

    private func fetch() async -> Result<ModelData, Error> {
        do {
            let point = try await environment.weatherService.points(latitude: location.latitude, longitude: location.longitude).properties
            let station = try await environment.weatherService.stations(for: point)
            return .success(ModelData(point: point, station: station))
        }
        catch {
            return .failure(error)
        }
    }
}

struct LocationData_Previews: PreviewProvider {
    static var previews: some View {
        LocationData(location: Location.boston)
            .environmentObject(Environment())
    }
}
