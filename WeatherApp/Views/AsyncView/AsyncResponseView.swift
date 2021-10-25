//
//  AsyncResponseView.swift
//  WeatherApp
//
//  Created by Paul Calnan on 10/25/21.
//

import SwiftUI

protocol AsyncResponseView: View {

    associatedtype ResponseType

    var response: ResponseType { get set }

    init(response: ResponseType)

    
}
