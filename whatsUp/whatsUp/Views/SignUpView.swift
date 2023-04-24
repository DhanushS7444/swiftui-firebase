//
//  SignUpView.swift
//  whatsUp
//
//  Created by Dhanush S on 07/04/23.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @State private var email: String = ""
    @State private var passWord: String = ""
    @State private var displayName: String = ""
    @State private var errorMessage: String = ""
    @EnvironmentObject private var appState : AppState
    @EnvironmentObject private var userModel: UserModel
    
    private var isFormValid: Bool {
        !email.isEmptyOrWhiteSpace && !passWord.isEmptyOrWhiteSpace && !displayName.isEmptyOrWhiteSpace
    }
    
    private func signUp() async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: passWord)
            try await userModel.updateDisplayName(for: result.user, displayName: displayName)
            appState.routes.append(.Login)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $passWord)
                .textInputAutocapitalization(.never)
            TextField("Display Name", text: $displayName)
            
            HStack {
                Spacer()
                Button("SignUp") {
                    Task {
                        await signUp()
                    }
                }.disabled(!isFormValid)
                    .buttonStyle(.borderless)
                
                Button("Login") {
                    appState.routes.append(.Login)
                }.buttonStyle(.borderless)
                Spacer()
            }
            Text(errorMessage)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(UserModel())
            .environmentObject(AppState())
        
    }
}
