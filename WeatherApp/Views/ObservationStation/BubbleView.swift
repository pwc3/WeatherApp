//
//  BubbleView.swift
//  WeatherApp
//
//  Copyright (c) 2021 Rocket Insights, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
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
        ZStack {
            Rectangle().background(.black)
            BubbleView(text: "KBOS")
        }
    }
}

