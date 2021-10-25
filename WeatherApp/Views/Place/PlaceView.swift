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
        Group {
            switch loadState {
            case .loading:
                ProgressView()
                    .onAppear {
                        Task {
                            self.loadState = await self.fetch()
                        }
                    }

            case .successful(let location):
                List {
                    Section {
                        ExpandableSectionToggle(title: "Forecast point", isExpanded: $isPointMetadataExpanded)
                        if isPointMetadataExpanded {
                            ForecastPointView(point: location.point)
                        }
                    }

                    Section(footer: Text("Select a station to see current conditions at that location")) {
                        ExpandableSectionToggle(title: "Observation stations", isExpanded: $isObservationStationListExpanded)
                        if isObservationStationListExpanded {
                            ObservationStationView(observationStations: location.observationStations)
                        }
                    }

                    Section {
                        NavigationLink(
                            destination: AsyncView(
                                title: "Hourly forecast",
                                provider: ForecastProvider(
                                    service: environment.weatherService,
                                    location: location,
                                    type: .hourly)))
                        {
                            Text("Hourly forecast")
                        }

                        NavigationLink(
                            destination: AsyncView(
                                title: "Seven-day forecast",
                                provider: ForecastProvider(
                                    service: environment.weatherService,
                                    location: location,
                                    type: .sevenDay)))
                        {
                            Text("Seven-day forecast")
                        }
                    }
                }

            case .failed(let error):
                ErrorView(error: error)
            }
        }
        .navigationTitle(place.name)
    }

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
        PlaceView(location: SampleData.location)
            .environmentObject(Environment())
    }
}
