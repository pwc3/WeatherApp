//
//  ErrorView.swift
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

struct ErrorView: View {

    var error: Error

    var onRetry: () -> Void

    @State private var isDetailExpanded = false

    var body: some View {
        Text("An error occurred")
            .font(.body)
            .fontWeight(.bold)

        ExpandableSectionToggle(title: "Details", isExpanded: $isDetailExpanded)

        if isDetailExpanded {
            Text(error.localizedDescription)
                .font(.body)
        }

        Button("Try again", action: onRetry)
    }
}

struct ErrorView_Previews: PreviewProvider {
    enum PreviewError: Error, LocalizedError {
        case error

        var errorDescription: String? {
            NSLocalizedString("Something didn't work as expected.", comment: "Preview-only error description")
        }
    }

    static var previews: some View {
        List {
            ErrorView(error: PreviewError.error, onRetry: { print("Retry tapped") })
        }
    }
}
