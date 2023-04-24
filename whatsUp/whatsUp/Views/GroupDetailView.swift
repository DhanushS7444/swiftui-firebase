//
//  GroupDetailView.swift
//  whatsUp
//
//  Created by Dhanush S on 13/04/23.
//

import SwiftUI
import FirebaseAuth

struct GroupDetailView: View {
    let group: Group
    @EnvironmentObject private var model : UserModel
    @State private var chatText: String = ""
    @State private var groupDetailConfig = GroupDetailConfig()
    @FocusState private var isChatTextFieldFocused: Bool
    
    private func sendMessage() async throws {
        guard let currentUser = Auth.auth().currentUser else {return}
        let chatMessage = ChatMessage(text: chatText, uid: currentUser.uid, displayName: currentUser.displayName ?? "Guest", profilePhotoURL: currentUser.photoURL == nil ? "" : currentUser.photoURL!.absoluteString)
        try await model.saveChatMessageToGroup(chatMessage: chatMessage, group: group)
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ChatMessageListView(chatMessages: model.chatMessages)
                    .onChange(of: model.chatMessages) { newValue in
                        if !model.chatMessages.isEmpty {
                            let lastMessages = model.chatMessages[model.chatMessages.endIndex - 1]
                            withAnimation {
                                proxy.scrollTo(lastMessages.id, anchor: .bottom)
                            }
                        }
                    }
            }
            
            Spacer()
        }.frame(maxWidth: .infinity)
            .padding()
            .confirmationDialog("options", isPresented: $groupDetailConfig.showOptions, actions: {
                Button("Camera") {
                    groupDetailConfig.sourceType = .camera
                }
                
                Button("Photo Library") {
                    groupDetailConfig.sourceType = .photoLibrary
                }
            })
            .sheet(item: $groupDetailConfig.sourceType, content: { sourceType in
                ImagePicker(image: $groupDetailConfig.selectedImage, sourceType: sourceType)
            })
            .overlay(alignment: .bottom, content: {
                ChatMessageInputView(groupDetailConfig: $groupDetailConfig, isChatTextFieldFocused: _isChatTextFieldFocused) {
                    //send the message
                    Task {
                        do {
                            try await sendMessage()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                }.padding()
            })
            .onDisappear{
                model.detachFirebaseListner()
            }
            .onAppear {
                model.listenForChatMessages(in: group)
            }
        
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(group: Group(subject: "Movies")).environmentObject(UserModel())
    }
}
