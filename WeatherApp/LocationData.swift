//
//  LocationData.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import SwiftUI
import WeatherAPI

struct LocationData: View {

    @EnvironmentObject var environment: Environment

    @StateObject var viewModel: LocationDataViewModel

    var body: some View {
        switch viewModel.state {
        case .loading:
            LoadingView()
                .onAppear {
                    viewModel.refresh(environment: environment)
                }
                .navigationTitle(viewModel.location.name)

        case .finished(let result):
            switch result {
            case .success(let point):
                List {
                    LocationDataRow(name: "Forecast office", value: point.forecastOfficeId)
                    LocationDataRow(name: "Grid ID", value: point.gridId)
                    LocationDataRow(name: "Grid X", value: point.gridX.description)
                    LocationDataRow(name: "Grid Y", value: point.gridY.description)
                    LocationDataRow(name: "Grid Y", value: point.radarStation)
                }
                .navigationTitle(viewModel.location.name)

            case .failure(let error):
                ErrorView(error: error)
            }
        }
    }
}

struct LocationData_Previews: PreviewProvider {
    static var previews: some View {
        LocationData(viewModel: LocationDataViewModel(location: Location.boston))
            .environmentObject(Environment())
    }
}

class LocationDataViewModel: ObservableObject {

    enum State {
        case loading
        case finished(Result<Point, Error>)
    }

    @Published private(set) var state: State = .loading

    let location: Location

    init(location: Location) {
        self.location = location
    }

    @MainActor
    func finish(with result: Result<Point, Error>) {
        state = .finished(result)
    }

    func refresh(environment: Environment) {
        Task {
            do {
                let feature = try await environment.weatherService.points(latitude: location.latitude,
                                                                          longitude: location.longitude)
                await finish(with: .success(feature.properties))
            }
            catch {
                await finish(with: .failure(error))
            }
        }
    }
}
