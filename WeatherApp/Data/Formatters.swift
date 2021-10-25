//
//  Formatters.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import Foundation

struct Formatters {
    static var timestampFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM d, h:mm a ZZZZ"
        return df
    }()
}
