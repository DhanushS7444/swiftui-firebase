//
//  ChatMessageView.swift
//  whatsUp
//
//  Created by Dhanush S on 13/04/23.
//

import SwiftUI
import FirebaseFirestore

enum chatMessageDirection {
    case left
    case right
}

struct ChatMessageView: View {
    let chatMessage: ChatMessage
    let direction : chatMessageDirection
    let color: Color
    
    @ViewBuilder
    private func profilePhotoForChatMessages(chatMessage: ChatMessage) -> some View {
        if let profilePhotoURL = chatMessage.displayProfilePhotoURL {
            AsyncImage(url: profilePhotoURL) { image in
                image.rounded(width: 34, height: 34)
            } placeholder: {
                Image(systemName: "person.crop.circle")
                    .font(.title)
            }
        } else {
            Image(systemName: "person.crop.circle")
                .font(.title)
        }
    }
    
    var body: some View {
        HStack {
            //Profile Photo
            
            if direction == .left {
                profilePhotoForChatMessages(chatMessage: chatMessage)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(chatMessage.displayName)
                    .opacity(0.8)
                    .font(.caption)
                    .foregroundColor(.white)
                
                //attachment photo URL
                Text(chatMessage.text)
                Text(chatMessage.dateCreated, format:.dateTime)
                    .opacity(0.4)
                    .font(.caption)
                    .frame(maxWidth: 200, alignment: .trailing)
            }.padding(8)
                .background(color)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            
            
               
            //profile photo
        }.listRowSeparator(.hidden)
            .overlay(alignment: direction == .left ? .bottomLeading : .bottomTrailing) {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.title)
                    .rotationEffect(.degrees(direction == .left ? 45 : -45))
                    .offset(x: direction == .left ? 30 : -30, y: 10)
                    .foregroundColor(color)
                
            }
        if direction == .right {
            profilePhotoForChatMessages(chatMessage: chatMessage)
        }
    }
}

struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageView(chatMessage: ChatMessage(documentId: "ABCD", text: "hellp", uid: "qwwerty", displayName: "Dhanush"), direction: .right, color: .blue)
    }
}
