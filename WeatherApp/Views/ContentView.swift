//
//  ContentView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import SwiftUI

struct ContentView: View {
    
    var places: [Place]

    var body: some View {
        PlaceList(places: places)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(places: Place.samples)
    }
}
