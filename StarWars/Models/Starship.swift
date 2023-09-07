//
//  Starship.swift
//  StarWars
//
//  Created by Denis Abramov on 04.09.2023.
//

import Foundation

struct Starship: Codable {
    let name: String
    let model: String
    let manufacturer: String
    let passengers: String
    let films: [String]
}
