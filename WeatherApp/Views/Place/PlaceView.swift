//
//  PlaceView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import SwiftUI
import WeatherAPI

struct PlaceView: View {

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

    var place: Place

    var body: some View {
        switch loadState {
        case .loading:
            ProgressView()
                .onAppear {
                    Task {
                        self.loadState = await self.fetch()
                    }
                }
                .navigationTitle(place.name)

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
            .navigationTitle(place.name)

        case .failed(let error):
            ErrorView(error: error)
        }
    }

    private func fetch() async -> LoadState {
        do {
            let point = try await environment.weatherService.points(latitude: place.latitude, longitude: place.longitude).properties
            let stations = try await environment.weatherService.stations(for: point)
            return .successful(ModelData(point: point, stations: stations))
        }
        catch {
            return .failed(error)
        }
    }
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceView(place: SampleData.places[0])
            .environmentObject(Environment())
    }
}
