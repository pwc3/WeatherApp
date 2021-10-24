//
//  TitleSubtitleRow.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/22/21.
//

import SwiftUI

struct TitleSubtitleRow: View {
    var title: String

    var subtitle: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.body)
            Text(subtitle)
                .font(.caption)
        }
    }
}

struct TitleSubtitleRow_Previews: PreviewProvider {
    static var previews: some View {
        TitleSubtitleRow(title: "Title value", subtitle: "Subtitle value")
    }
}
