//
//  ObservationView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import SwiftUI
import WeatherAPI

struct ObservationView: View {

    private enum LoadState {
        case loading
        case successful(Observation)
        case failed(Error)
    }

    @EnvironmentObject var environment: Environment

    @State private var loadState: LoadState = .loading

    var station: ObservationStation

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

            case .successful(let observation):
                ObservationDetails(station: station, observation: observation)

            case .failed(let error):
                ErrorView(error: error)
            }
        }
        .navigationTitle("Conditions at \(station.stationIdentifier)")
    }

    private func fetch() async -> LoadState {
        do {
            return .successful(try await station.latestObservation(using: environment.weatherService))
        }
        catch {
            return .failed(error)
        }
    }
}

struct ObservationView_Previews: PreviewProvider {
    static var previews: some View {
        ObservationView(station: SampleData.observationStations[0])
            .environmentObject(Environment())
    }
}
