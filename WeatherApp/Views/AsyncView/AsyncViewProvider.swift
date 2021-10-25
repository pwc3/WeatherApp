//
//  AsyncViewProvider.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/25/21.
//

import SwiftUI

protocol AsyncViewProvider {

    associatedtype ResponseType

    associatedtype Body: View

    func run() async throws -> ResponseType

    func createView(with response: ResponseType) -> Body
}
