//
//  Response.swift
//  StarWars
//
//  Created by Denis Abramov on 05.09.2023.
//

import Foundation

struct Response<T: Codable>: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [T]
}
