//
//  LoadDecodableFromFile.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import Foundation

func load<T: Decodable>(fromFilename filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Could not find \(filename) in the main bundle")
    }

    do {
        data = try Data(contentsOf: file)
    }
    catch {
        fatalError("Error loading \(filename) from main bundle: \(error)")
    }

    do {
        return try JSONDecoder().decode(T.self, from: data)
    }
    catch {
        fatalError("Error parsing \(filename) at \(T.self): \(error)")
    }
}
