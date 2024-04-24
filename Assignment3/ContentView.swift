//
// ContentView.swift : Assignment3
//
// Copyright © 2023 Auburn University.
// All Rights Reserved.

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }
}

struct ContentView: View {
    @ObservedObject var viewModel = CharacterViewModel()
    @State private var characterID: String = ""
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var username: String = "";
    @State var password: String = "";
    @State private var isAuthenticated: Bool = false
    let authenticationManager = AuthenticationManager()
    
    var body: some View {
        VStack {
            Text("Login")
            HStack {
                Text("Username: ")
                TextField("user", text: $username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            HStack {
                Text("Password: ")
                TextField("pass", text: $password)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            Button ("Submit") {
                authenticationManager.authenticate(username: username, password: password) { success, error in
                    isAuthenticated = success
                    if let error = error {
                        // Handle authentication error
                        print("Authentication error:", error.localizedDescription)
                    }
                }
            }
            Text("Rick and Morty Character Locator").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Text("Authenticated: \(isAuthenticated ? "Yes" : "No")")
                .padding()
                .padding()
            TextField("Character ID", text: $characterID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Fetch Character") {
                if (isAuthenticated) {
                    if let id = Int(characterID) {
                        fetchCharacter(id: id)
                    }
                } else {
                    print("Please login!")
                }
            }.buttonStyle(BorderedButtonStyle())
                .padding()
            
            if let character = viewModel.character {
                Text("Name: \(character.name)")
                Text("Current Location: \(character.location.name)")
                Button("Refresh") {
                    if let id = Int(characterID) {
                        fetchCharacter(id: id)
                    }
                }
            } else {
                Text("")
            }
        }
        .onAppear {
            //viewModel.fetchCharacter()
        }
        .padding()
    }
    
    private func fetchCharacter(id: Int) {
        let urlString = "https://rickandmortyapi.com/api/character/\(id)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            if let decodedResponse = try? JSONDecoder().decode(Character.self, from: data) {
                DispatchQueue.main.async {
                    viewModel.character = decodedResponse
                }
                return
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

