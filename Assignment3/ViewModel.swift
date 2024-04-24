//
//  ViewModel.swift
//  Assignment3
//
//  Created by Michael Baljet on 3/31/24.
//

import Foundation
import Combine

import Foundation
import Combine

struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let origin: Location
    let location: Location
}

struct Location: Codable {
    let name: String
    let url: String
}

class CharacterViewModel: ObservableObject {
    @Published var character: Character?
    
    private var cancellable: AnyCancellable?
    
    func fetchCharacter() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character/1") else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Character?.self, decoder: JSONDecoder()) 
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] character in
                self?.character = character 
            })
    }
}
