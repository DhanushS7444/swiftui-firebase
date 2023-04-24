//
//  AppState.swift
//  whatsUp
//
//  Created by Dhanush S on 07/04/23.
//

import Foundation

enum Route: Hashable {
    case main
    case Login
    case signUp
}

class AppState: ObservableObject {
    @Published var routes: [Route] = []
}
