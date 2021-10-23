//
//  ContentView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import SwiftUI

struct ContentView: View {
    
    var locations: [Location]

    var body: some View {
        LocationList(locations: locations)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(locations: Location.all)
    }
}
