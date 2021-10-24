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

    static var observationStations: FeatureCollection<ObservationStation> = {
        load(fromFilename: "ObservationStationsResponse.json")
    }()
}
