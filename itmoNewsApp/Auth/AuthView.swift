//
//  AuthView.swift
//  itmoNewsApp
//
//  Created by Уля on 21.03.2025.
//

import SwiftUI

struct AuthView: View {
    
    @ObservedObject var viewModel: AuthViewModel
    @Binding var isAuth: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text("Auth")
                .monospaced()
                .font(.title)
            
            
            TextField("Username", text: $viewModel.username)
                .monospaced()
                .padding(.leading, 100)
            
            SecureField("Password", text: $viewModel.password)
                .monospaced()
                .padding(.leading, 100)
            
            if viewModel.error != "" {
                Text(viewModel.error)
                    .monospaced()
                    .foregroundStyle(Color.red)
                    .frame(width: 200)
            }
            
            
            Button {
                viewModel.check()
                if !viewModel.isAuth {
                    isAuth = false
                }
            } label: {
                Text("GO")
            }.buttonStyle(.plain)
            .monospaced()
            Spacer()
        }
        .padding()
    }
}


class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var error: String = ""
    
    @Published var isAuth: Bool = true
    
    func check() {
        if username.count < 10 {
            error = "username should contain more than 10 symbols"
        } else {
            isAuth = false
        }
    }
}
