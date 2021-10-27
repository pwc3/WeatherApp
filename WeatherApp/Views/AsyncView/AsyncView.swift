//
//  AsyncView.swift
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

struct AsyncView<ResponseType, ProviderType>: View
where ProviderType: AsyncViewProvider, ProviderType.ResponseType == ResponseType
{
    private enum LoadState {
        case loading
        case successful(ResponseType)
        case failed(Error)
    }

    @State private var loadState: LoadState = .loading

    var title: String

    var provider: ProviderType

    var body: some View {
        Group {
            switch loadState {
            case .loading:
                ProgressView()
                    .onAppear {
                        Task {
                            do {
                                self.loadState = .successful(try await provider.run())
                            }
                            catch {
                                self.loadState = .failed(error)
                            }
                        }
                    }

            case .successful(let response):
                provider.createView(with: response)

            case .failed(let error):
                VStack(alignment: .center, spacing: 10) {
                    Text("An error occurred")
                        .font(.headline)

                    Text(error.localizedDescription)
                        .font(.caption)

                    Button("Retry") {
                        loadState = .loading
                    }
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct AsyncView_Previews: PreviewProvider {
    static var previews: some View {
        Text("No preview provided")
    }
}

