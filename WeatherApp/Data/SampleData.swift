//
//  SampleData.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import Foundation
import WeatherAPI

struct SampleData {

    static var places: [Place] = {
        load(fromFilename: "Places.json")
    }()

    static var point: Point = {
        let feature: Feature<Point> = load(fromFilename: "PointResponse.json")
        return feature.properties
    }()

    static var observationStations: [ObservationStation] = {
        let collection: FeatureCollection<ObservationStation> = load(fromFilename: "ObservationStationsResponse.json")
        return collection.features.map { $0.properties }
    }()

    static var location: Location = {
        Location(id: UUID(), place: places[0], point: point, observationStations: observationStations)
    }()

    static var observation: Observation = {
        let feature: Feature<Observation> = load(fromFilename: "Observation.json")
        return feature.properties
    }()
}
