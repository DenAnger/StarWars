//
//  MainViewController.swift
//  StarWars
//
//  Created by Denis Abramov on 05.09.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var searchBar: UISearchBar!
    
    private var searchResults: [Any] = []
    private var characterResults: [Character] = []
    private var starshipResults: [Starship] = []
    private var planetResults: [Planet] = []
    
    private var favorites = Favorites.load() ?? Favorites(characters: [],
                                                  starships: [],
                                                  planets: [],
                                                  films: [])

    private let starWarsAPI = StarWarsAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = searchResults[indexPath.row]
        
        if let character = item as? Character {
            cell.textLabel?.text = "Character: \(character.name)"
            cell.detailTextLabel?.text = "Gender: \(character.gender), Starships: \(character.starships.count)"
        } else if let starship = item as? Starship {
            cell.textLabel?.text = "Starship: \(starship.name)"
            cell.detailTextLabel?.text = "Model: \(starship.model), Manufacturer: \(starship.manufacturer), Pass: \(starship.passengers)"
        } else if let planet = item as? Planet {
            cell.textLabel?.text = "Planet: \(planet.name)"
            cell.detailTextLabel?.text = "Diameter: \(planet.diameter), Population: \(planet.population)"
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = searchResults[indexPath.row]
        
        if let character = selectedItem as? Character,
           !favorites.characters.contains(where: { $0.name == character.name }) {
            favorites.addToFavorites(item: selectedItem)
        } else if let starship = selectedItem as? Starship,
                  !favorites.starships.contains(where: { $0.name == starship.name }) {
            favorites.addToFavorites(item: selectedItem)
        } else if let planet = selectedItem as? Planet,
                  !favorites.planets.contains(where: { $0.name == planet.name }) {
            favorites.addToFavorites(item: selectedItem)
        }
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count >= 2 {
            starWarsAPI.searchCharacters(query: searchText) { [weak self] (characterResults, error) in
                
                guard let self = self else { return }
                
                if let characterResults = characterResults {
                    self.searchResults = characterResults
                } else if let error = error {
                    print("Error searching characters: \(error.localizedDescription)")
                    self.searchResults = []
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            starWarsAPI.searchStarships(query: searchText) { [weak self] (starshipResults, error) in
                
                guard let self = self else { return }
                
                if let starshipResults = starshipResults {
                    self.searchResults.append(contentsOf: starshipResults)
                } else if let error = error {
                    print("Error searching starships: \(error.localizedDescription)")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            starWarsAPI.searchPlanets(query: searchText) { [weak self] (planetResults, error) in
                
                guard let self = self else { return }
                
                if let planetResults = planetResults {
                    self.searchResults.append(contentsOf: planetResults)
                } else if let error = error {
                    print("Error searching starships: \(error.localizedDescription)")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else {
            searchResults = []
            tableView.reloadData()
        }
    }
}
