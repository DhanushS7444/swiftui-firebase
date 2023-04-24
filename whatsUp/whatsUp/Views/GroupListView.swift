//
//  GroupListView.swift
//  whatsUp
//
//  Created by Dhanush S on 11/04/23.
//

import SwiftUI

struct GroupListView: View {
    
    let groups: [Group]
    var body: some View {
        
        List(groups) { group in
            NavigationLink {
               GroupDetailView(group: group)
            } label: {
                HStack {
                    Image(systemName: "person.2")
                    Text(group.subject)
                }
            }
        }
    }
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView(groups: [])
    }
}
