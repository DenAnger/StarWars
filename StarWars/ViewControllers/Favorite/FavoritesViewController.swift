//
//  FavoritesViewController.swift
//  StarWars
//
//  Created by Denis Abramov on 05.09.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private var favorites: Favorites = Favorites(characters: [],
                                         starships: [],
                                         planets: [],
                                         films: [])
    
    private var item: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        favorites.save()
    }
    
    // MARK: - Favorites

    /// Добавление в список избранного
    /// - Parameters:
    ///   - favorite: тип элемента
    ///   - list: список избранного
    private func addFavorite<T>(_ favorite: T, to list: inout [T]) {
        list.append(favorite)
    }

    /// Удаление из избранного
    /// - Parameters:
    ///   - index: индекс элемента
    ///   - list: список избранного
    private func removeFavorite<T>(at index: Int, from list: inout [T]) {
        list.remove(at: index)
    }

    /// Обновление избранного
    /// - Parameters:
    ///   - favorite: тип элемента
    ///   - index: индекс элемента
    ///   - list: список избранного
    private func updateFavorite<T>(_ favorite: T, at index: Int, in list: inout [T]) {
        list[index] = favorite
    }

    /// Загрузка избранного списка
    private func loadFavorites() {

        if let savedFavorites = Favorites.load() {
            favorites = savedFavorites
        }
    }
    
    // MARK: - Films
    
    private func addFilmsToCell(_ films: [Film], cell: FavoritesTableViewCell) {
        let filmsDetails = films.map {
            "\($0.title) (Director: \($0.director), Producer: \($0.producer))"
        }.joined(separator: ", ")
        
        DispatchQueue.main.async {
            cell.filmsTextView.text = "Films: \(filmsDetails)"
        }
    }
    
    private func getFilmFromUrl(_ url: String, completion: @escaping (Film?) -> Void) {
       
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data,
                  let film = try? JSONDecoder().decode(Film.self, from: data) else {
                completion(nil)
                return
            }
            completion(film)
        }
        task.resume()
    }
}

// MARK: - Table view data source
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.characters.count + favorites.starships.count + favorites.planets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavoritesTableViewCell

        var name = ""
        var details = ""

        if indexPath.row < favorites.characters.count {
            let character = favorites.characters[indexPath.row]
            item = character
            name = character.name
            details = "Gender: \(character.gender), Starships: \(character.starships.count)"

            for url in character.films {
                getFilmFromUrl(url) { film in
                    
                    if let film = film {
                        self.favorites.films.append(film)
                        self.addFilmsToCell(self.favorites.films, cell: cell)
                    }
                }
            }

        } else if indexPath.row < favorites.characters.count + favorites.starships.count {
            let starshipIndex = indexPath.row - favorites.characters.count
            let starship = favorites.starships[starshipIndex]
            item = starship
            name = starship.name
            details = "Model: \(starship.model), Manufacturer: \(starship.manufacturer), Passengers: \(starship.passengers)"

            for url in starship.films {
                getFilmFromUrl(url) { film in
                   
                    if let film = film {
                        self.favorites.films.append(film)
                        self.addFilmsToCell(self.favorites.films, cell: cell)
                    }
                }
            }
        } else if indexPath.row < favorites.characters.count + favorites.starships.count + favorites.planets.count {
            let planetIndex = indexPath.row - favorites.characters.count - favorites.starships.count
            let planet = favorites.planets[planetIndex]
            name = planet.name
            details = "Diameter: \(planet.diameter), Population: \(planet.population)"
        }

        cell.nameLabel.text = name
        cell.detailLabel.text = details
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if indexPath.row < favorites.characters.count {
                favorites.characters.remove(at: indexPath.row)
            } else if indexPath.row < favorites.characters.count + favorites.starships.count {
                let starshipIndex = indexPath.row - favorites.characters.count
                favorites.starships.remove(at: starshipIndex)
            } else if indexPath.row < favorites.characters.count + favorites.starships.count + favorites.planets.count {
                let planetIndex = indexPath.row - favorites.characters.count - favorites.starships.count
                favorites.planets.remove(at: planetIndex)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < favorites.characters.count {
            _ = favorites.characters[indexPath.row]
        } else if indexPath.row < favorites.characters.count + favorites.starships.count {
            let starshipIndex = indexPath.row - favorites.characters.count
            _ = favorites.starships[starshipIndex]
        } else if indexPath.row < favorites.characters.count + favorites.starships.count + favorites.planets.count {
            let planetIndex = indexPath.row - favorites.characters.count - favorites.starships.count
            _ = favorites.planets[planetIndex]
        }
    }
}
