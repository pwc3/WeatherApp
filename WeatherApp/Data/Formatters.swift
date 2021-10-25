//
//  Formatters.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import Foundation

struct Formatters {
    static var hour: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "h a"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()

    static var timestamp: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM d, h:mm a ZZZZ"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
}
