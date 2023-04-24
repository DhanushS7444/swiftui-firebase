//
//  whatsUpApp.swift
//  whatsUp
//
//  Created by Dhanush S on 07/04/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate : NSObject , UIApplicationDelegate {
    func application ( _ application : UIApplication,
                       didFinishLaunchingWithOptions launchOptions : [ UIApplication . LaunchOptionsKey : Any ]? = nil ) -> Bool {
        FirebaseApp.configure ()
        return true
    }
}

@main
struct whatsUpApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor (AppDelegate.self) var delegate
    @StateObject private var userModel = UserModel()
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appState.routes) {
                ZStack {
                    if Auth.auth().currentUser != nil {
                        MainView()
                    } else {
                        LoginView()
                    }
                }.navigationDestination(for: Route.self) { route in
                    switch route {
                    case .main:
                        MainView()
                    case .Login:
                        LoginView()
                    case .signUp:
                        SignUpView()
                    }
                }
            }.environmentObject(appState)
            .environmentObject(userModel)
        }
    }
}
