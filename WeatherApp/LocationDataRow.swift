//
//  LocationDataRow.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import SwiftUI

struct LocationDataRow: View {
    var name: String

    var value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.body)
            Text(value)
                .font(.caption)
        }
    }
}

struct LocationDataRow_Previews: PreviewProvider {
    static var previews: some View {
        LocationDataRow(name: "Field name", value: "Field value")
    }
}
