//
//  AsyncView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/25/21.
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
    }
}

struct AsyncView_Previews: PreviewProvider {
    static var previews: some View {
        Text("No preview provided")
    }
}
