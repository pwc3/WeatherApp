//
//  PlaceList.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import SwiftUI

struct PlaceList: View {
    
    @EnvironmentObject var environment: Environment

    var places: [Place]

    var body: some View {
        NavigationView {
            List {
                ForEach(places) { place in
                    NavigationLink(destination:asyncLocationView(for: place)) {
                        Text(place.name)
                    }
                }
            }
            .navigationTitle("Places")
        }
    }

    private func asyncLocationView(for place: Place) -> some View {
        AsyncView(title: place.name,
                  provider: LocationProvider(service: environment.weatherService,
                                             place: place))
    }
}

struct PlaceList_Previews: PreviewProvider {
    static var previews: some View {
        PlaceList(places: SampleData.places)
    }
}
