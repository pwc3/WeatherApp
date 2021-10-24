//
//  ExpandableSectionToggle.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/24/21.
//

import SwiftUI

struct ExpandableSectionToggle: View {
    var title: String

    @Binding var isExpanded: Bool

    var body: some View {
        Button(action: {
            withAnimation {
                isExpanded.toggle()
            }
        }) {
            HStack {
                Text(title)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: "chevron.right.circle")
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
            }
        }
        .foregroundColor(.primary)
    }
}

struct ExpandableSectionToggle_Previews: PreviewProvider {
    static var previews: some View {
        ExpandableSectionToggle(title: "Expandable row", isExpanded: .constant(true))
    }
}
