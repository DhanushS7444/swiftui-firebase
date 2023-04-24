//
//  MainView.swift
//  whatsUp
//
//  Created by Dhanush S on 07/04/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        
        TabView {
            Text("Status")
                .tabItem {
                    Label("Status", systemImage: "circle.dashed")
                }
            Text("Calls")
                .tabItem {
                    Label("Calls", systemImage: "phone.fill")
                }
            GroupListContainerView()
                .tabItem {
                    Label("Chats", systemImage: "message.fill")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
