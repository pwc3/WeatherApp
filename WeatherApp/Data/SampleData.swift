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
        load(fromFilename: "PointResponse.json")
    }()

    static var observationStations: FeatureCollection<ObservationStation> = {
        load(fromFilename: "ObservationStationsResponse.json")
    }()
}
