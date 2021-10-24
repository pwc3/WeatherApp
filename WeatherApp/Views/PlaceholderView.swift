//
//  PlaceholderView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import SwiftUI

struct PlaceholderView: View {
    var title: String
    var location: Location

    var body: some View {
        VStack {
            Text("Placeholder")
                .font(.headline)

            Text(title)
                .font(.subheadline)

            Spacer()
                .frame(height: 20)

            Text(location.place.name)
                .font(.body)
        }
        .navigationTitle(title)
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderView(title: "Title", location: SampleData.location)
    }
}
