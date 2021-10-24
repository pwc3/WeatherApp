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
        var stations: FeatureCollection<ObservationStation>
    }

    private enum LoadState {
        case loading
        case finished(Result<ModelData, Error>)
    }

    @EnvironmentObject var environment: Environment

    @State private var loadState: LoadState = .loading

    @State private var isPointMetadataExpanded = false

    @State private var isObservationStationListExpanded = false

    var location: Location

    var body: some View {
        switch loadState {
        case .loading:
            ProgressView()
                .onAppear {
                    Task {
                        self.loadState = .finished(await self.fetch())
                    }
                }
                .navigationTitle(location.name)

        case .finished(let result):
            switch result {
            case .success(let modelData):
                List {
                    Section {
                        ExpandableSectionToggle(title: Text("Forecast point"), isExpanded: $isPointMetadataExpanded)
                        if isPointMetadataExpanded {
                            PointMetadataView(point: modelData.point)
                        }
                    }

                    Section {
                        ExpandableSectionToggle(title: Text("Nearby observation stations"), isExpanded: $isObservationStationListExpanded)
                        if isObservationStationListExpanded {
                            ObservationStationListView(observationStations: modelData.stations)
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
            let stations = try await environment.weatherService.stations(for: point)
            return .success(ModelData(point: point, stations: stations))
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
