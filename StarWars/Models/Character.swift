//
//  Character.swift
//  StarWars
//
//  Created by Denis Abramov on 04.09.2023.
//

import Foundation

struct Character: Codable {
    let name: String
    let gender: String
    let starships: [String]
    let films: [String]
}
