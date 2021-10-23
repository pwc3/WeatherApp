//
//  ErrorView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import SwiftUI
import WeatherAPI

struct ErrorView: View {
    var error: Error

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("An error occurred")
                .font(.headline)
            Text(error.localizedDescription)
                .font(.caption)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: ServiceError.errorStatusCode(404))
    }
}
