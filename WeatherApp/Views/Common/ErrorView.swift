//
//  ErrorView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 11/2/21.
//

import SwiftUI

struct ErrorView: View {

    var error: Error

    var onRetry: () -> Void

    @State private var isDetailExpanded = false

    var body: some View {
        Text("An error occurred")
            .font(.body)
            .fontWeight(.bold)

        ExpandableSectionToggle(title: "Details", isExpanded: $isDetailExpanded)

        if isDetailExpanded {
            Text(error.localizedDescription)
                .font(.body)
        }

        Button("Try again", action: onRetry)
    }
}

struct ErrorView_Previews: PreviewProvider {
    enum PreviewError: Error {
        case error
    }

    static var previews: some View {
        List {
            ErrorView(error: PreviewError.error, onRetry: { print("Retry tapped") })
        }
    }
}
