//
//  Place+Sample.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/25/21.
//

import Foundation

extension Place {

    static var samples: [Place] {
        load(fromFilename: "Places.json")
    }
}
