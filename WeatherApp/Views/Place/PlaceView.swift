//
//  PlaceView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import SwiftUI
import WeatherAPI

struct PlaceView: View {

    private enum LoadState {
        case loading
        case successful(Location)
        case failed(Error)
    }

    @EnvironmentObject var environment: Environment

    @State private var loadState: LoadState = .loading

    @State private var isPointMetadataExpanded = false

    @State private var isObservationStationListExpanded = false

    var place: Place

    init(place: Place) {
        self.place = place
    }

    init(location: Location) {
        self.place = location.place
        loadState = .successful(location)
    }

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

        case .successful(let location):
            List {
                Section {
                    ExpandableSectionToggle(title: "Forecast point", isExpanded: $isPointMetadataExpanded)
                    if isPointMetadataExpanded {
                        ForecastPointView(point: location.point)
                    }
                }

                Section {
                    ExpandableSectionToggle(title: "Nearby observation stations", isExpanded: $isObservationStationListExpanded)
                    if isObservationStationListExpanded {
                        ObservationStationView(observationStations: location.observationStations)
                    }
                }

                Section {
                    NavigationLink(destination: ObservationView(title: "Latest observation", location: location)) {
                        Text("Latest observation")
                    }

                    NavigationLink(destination: ForecastView(title: "Forecast", location: location)) {
                        Text("Forecast")
                    }

                    NavigationLink(destination: ForecastView(title: "Hourly forecast", location: location)) {
                        Text("Hourly forecast")
                    }
                }
            }
            .navigationTitle(place.name)

        case .failed(let error):
            ErrorView(error: error)
        }
    }

    typealias ObservationView = PlaceholderView

    typealias ForecastView = PlaceholderView

    private func fetch() async -> LoadState {
        do {
            return .successful(try await Location.fetch(using: environment.weatherService, for: place))
        }
        catch {
            return .failed(error)
        }
    }
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceView(location: Location(id: UUID(),
                                     place: SampleData.places[0],
                                     point: SampleData.point,
                                     observationStations: SampleData.observationStations))
            .environmentObject(Environment())
    }
}
