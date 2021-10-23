//
//  Result+Async.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/23/21.
//

import Foundation

extension Result where Failure == Swift.Error {
    init(catchingAsync body: () async throws -> Success) async {
        do {
            self = .success(try await body())
        }
        catch {
            self = .failure(error)
        }
    }
}
