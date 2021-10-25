//
//  OptionalRow.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import SwiftUI

struct OptionalRow: View {

    var title: String

    var value: String?

    init(_ title: String, _ value: String?) {
        self.title = title
        self.value = value
    }

    var body: some View {
        if let value = value {
            VStack(alignment: .leading) {
                Text(title).font(.caption)
                Text(value).font(.body)
            }
        }
    }
}

struct OptionalRow_Previews: PreviewProvider {
    static var previews: some View {
        OptionalRow("Title", "Value")
    }
}