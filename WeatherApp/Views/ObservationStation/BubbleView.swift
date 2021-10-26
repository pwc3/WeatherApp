//
//  BubbleView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/26/21.
//

import SwiftUI

struct BubbleView: View {
    var backgroundColor = Color(white: 1.0, opacity: 0.85)

    var text: String

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(text)
                .font(.caption)
                .fontWeight(.bold)
                .padding(5)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(5)

            GeometryReader { geometry in
                let maxX = geometry.size.width
                let midX = geometry.size.width / 2
                let maxY = geometry.size.height

                Path { path in
                    path.move(to: .zero)
                    path.addLines([
                        CGPoint(x: maxX, y: 0),
                        CGPoint(x: midX, y: maxY),
                        .zero
                    ])
                }
                .fill(Color(UIColor.systemBackground))
            }
            .frame(width: 10, height: 10, alignment: .center)
        }
    }
}

struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleView(text: "KBOS")
    }
}
