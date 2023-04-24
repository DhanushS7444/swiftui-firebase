//
//  LoginView.swift
//  whatsUp
//
//  Created by Dhanush S on 07/04/23.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var passWord: String = ""
    @EnvironmentObject private var appState: AppState
    
    private var isFormValid: Bool {
        !email.isEmptyOrWhiteSpace && !passWord.isEmptyOrWhiteSpace
    }
    
    private func login() async {
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: passWord)
            appState.routes.append(.main)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $passWord)
                .textInputAutocapitalization(.never)
            HStack {
                Spacer()
                Button("Login") {
                    Task {
                       await login()
                    }
                }.disabled(!isFormValid)
                    .buttonStyle(.borderless)
                
                Button("SignUp") {
                    appState.routes.append(.signUp)
                }.buttonStyle(.borderless)
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AppState())
    }
}
