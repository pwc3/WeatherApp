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
        case successful(ModelData)
        case failed(Error)
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
                        self.loadState = await self.fetch()
                    }
                }
                .navigationTitle(location.name)

        case .successful(let modelData):
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

        case .failed(let error):
            ErrorView(error: error)
        }
    }

    private func fetch() async -> LoadState {
        do {
            let point = try await environment.weatherService.points(latitude: location.latitude, longitude: location.longitude).properties
            let stations = try await environment.weatherService.stations(for: point)
            return .successful(ModelData(point: point, stations: stations))
        }
        catch {
            return .failed(error)
        }
    }
}

struct LocationData_Previews: PreviewProvider {
    static var previews: some View {
        LocationData(location: Location.boston)
            .environmentObject(Environment())
    }
}
