//
//  LocationList.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import SwiftUI

struct LocationList: View {
    
    @EnvironmentObject var environment: Environment

    var locations: [Location]

    var body: some View {
        NavigationView {
            List {
                ForEach(locations) {
                    LocationRow(location: $0)
                }
            }
            .navigationTitle("Locations")
        }
    }
}

struct LocationList_Previews: PreviewProvider {
    static var previews: some View {
        LocationList(locations: Location.all)
    }
}
