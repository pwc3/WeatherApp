//
//  ObservationStationsMapView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/26/21.
//

import SwiftUI
import WeatherAPI
import MapKit

struct ObservationStationsMapView: View {
    @EnvironmentObject var environment: Environment

    var stations: FeatureCollection<ObservationStation>

    private struct Station: Identifiable {
        var id: String {
            station.properties.stationIdentifier
        }

        var station: Feature<ObservationStation>

        var location: CLLocationCoordinate2D

        init?(_ station: Feature<ObservationStation>) {
            guard let location = station.geometry.asCLLocationCoordinate2D else {
                return nil
            }
            self.station = station
            self.location = location
        }
    }

    private struct CoordinateRange {
        var minLat = Double.infinity
        var maxLat = -Double.infinity

        var minLon = Double.infinity
        var maxLon = -Double.infinity

        mutating func update(with coord: CLLocationCoordinate2D) {
            minLat = min(minLat, coord.latitude)
            maxLat = max(maxLat, coord.latitude)

            minLon = min(minLon, coord.longitude)
            maxLon = max(maxLon, coord.longitude)
        }

        func updated(with coord: CLLocationCoordinate2D) -> CoordinateRange {
            var copy = self
            copy.update(with: coord)
            return copy
        }

        var region: MKCoordinateRegion {
            let latSpan = maxLat - minLat
            let lonSpan = maxLon - minLon

            let spanMultiplier = 1.10

            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: minLat + (latSpan / 2.0),
                                               longitude: minLon + (lonSpan / 2.0)),
                span: MKCoordinateSpan(latitudeDelta: latSpan * spanMultiplier,
                                       longitudeDelta: lonSpan * spanMultiplier))
        }
    }

    init(stations: FeatureCollection<ObservationStation>) {
        self.stations = stations

        let range = stations.features.compactMap {
            $0.geometry.asCLLocationCoordinate2D
        }.reduce(CoordinateRange(), { $0.updated(with: $1) })
        region = range.region
    }

    @State private var region: MKCoordinateRegion

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            Map(coordinateRegion: $region,
                annotationItems: stations.features.compactMap { Station($0) })
            { station in
                MapAnnotation(coordinate: station.location, anchorPoint: CGPoint(x: 0.5, y: 1.0)) {
                    VStack {
                        NavigationLink(destination: asyncObservationView(for: station.station)) {
                            BubbleView(text: station.id)
                        }
                    }
                }
            }

            Text("Select a station to see current conditions")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(5)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(5)
                .padding(.top, 10)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Stations")
        .edgesIgnoringSafeArea([.bottom])
    }

    private func asyncObservationView(for station: Feature<ObservationStation>) -> some View {
        AsyncView(title: station.properties.stationIdentifier,
                  provider: ObservationProvider(service: environment.weatherService,
                                                station: station))
    }
}

import SampleWeatherData

struct ObservationStationsMapView_Previews: PreviewProvider {
    static var previews: some View {
        ObservationStationsMapView(stations: SampleData.observationStations)
    }
}
