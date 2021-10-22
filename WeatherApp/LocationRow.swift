//
//  LocationRow.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import CoreLocation
import SwiftUI

struct LocationRow: View {
    var location: Location

    var body: some View {
        NavigationLink(destination: LocationData(viewModel: LocationDataViewModel(location: location))) {
            Text(location.name)
                .foregroundColor(.primary)
        }
    }
}

struct LocationRow_Previews: PreviewProvider {
    static var previews: some View {
        LocationRow(location: Location.boston)
    }
}
