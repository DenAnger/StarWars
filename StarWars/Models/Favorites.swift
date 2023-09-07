//
//  Favorites.swift
//  StarWars
//
//  Created by Denis Abramov on 05.09.2023.
//

import Foundation

struct Favorites: Codable {
    var characters: [Character]
    var starships: [Starship]
    var planets: [Planet]
    var films: [Film]
    
    func save() {
        
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(self)
            UserDefaults.standard.set(encodedData, forKey: "favorites")
        } catch {
            print("Error encoding favorites: \(error.localizedDescription)")
        }
    }
    
    static func load() -> Favorites? {
        
        guard let encodedData = UserDefaults.standard.data(forKey: "favorites") else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode(Favorites.self, from: encodedData)
            return favorites
        } catch {
            print("Error decoding favorites: \(error.localizedDescription)")
            return nil
        }
    }
    
    mutating func addToFavorites(item: Any) {
        switch item {
        case let character as Character:
            characters.append(character)
        case let starship as Starship:
            starships.append(starship)
        case let planet as Planet:
            planets.append(planet)
        case let film as Film:
            films.append(film)
        default:
            break
        }
        save()
    }
}
