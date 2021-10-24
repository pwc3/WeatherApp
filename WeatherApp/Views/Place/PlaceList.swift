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
                    NavigationLink(destination: PlaceView(place: place)) {
                        Text(place.name)
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle("Places")
        }
    }
}

struct PlaceList_Previews: PreviewProvider {
    static var previews: some View {
        PlaceList(places: SampleData.places)
    }
}
