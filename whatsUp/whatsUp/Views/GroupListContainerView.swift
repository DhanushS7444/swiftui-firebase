//
//  GroupListContainerView.swift
//  whatsUp
//
//  Created by Dhanush S on 08/04/23.
//

import SwiftUI

struct GroupListContainerView: View {
    
    @EnvironmentObject private var model : UserModel
    @State private var isPresented: Bool = false
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("New Group") {
                    isPresented = true
                }
            }
            GroupListView(groups: model.groups)
            Spacer()
        }
        .task {
            do {
                try await model.populateGroups()
            } catch {
                print(error.localizedDescription)
            }
        }
        .padding()
            .sheet(isPresented: $isPresented) {
                AddNewGroupView()
            }
    }
}

struct GroupListContainerView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListContainerView().environmentObject(UserModel())
    }
}
