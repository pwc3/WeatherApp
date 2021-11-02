//
//  LoadingView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 11/2/21.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer(minLength: 24)
            HStack {
                Spacer()
                VStack(alignment: .center, spacing: 8) {
                    Text("Loading")
                    ProgressView()
                }
                Spacer()
            }
            Spacer(minLength: 24)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            LoadingView()
        }
    }
}
