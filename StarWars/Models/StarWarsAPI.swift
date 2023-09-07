//
//  StarWarsAPI.swift
//  StarWars
//
//  Created by Denis Abramov on 04.09.2023.
//

import Foundation

class StarWarsAPI {
    
    private let baseURL = "https://swapi.dev/api/"

    func searchCharacters(query: String,
                          completion: @escaping ([Character]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)people/?search=\(query)")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, nil)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(Response<Character>.self, from: data)
                completion(result.results, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }

    func searchStarships(query: String,
                         completion: @escaping ([Starship]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)starships/?search=\(query)")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
           
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, nil)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(Response<Starship>.self, from: data)
                completion(result.results, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }

    func searchPlanets(query: String,
                       completion: @escaping ([Planet]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)planets/?search=\(query)")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, nil)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(Response<Planet>.self, from: data)
                completion(result.results, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
