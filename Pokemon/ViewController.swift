//
//  ViewController.swift
//  Pokemon
//
//  Created by Field Employee on 12/12/20.
// Architecture: MVC

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var PokemonTableView: UITableView!
    
    @IBOutlet weak var pokemonImage: UIImageView?
    @IBOutlet weak var pokemonLabel: UILabel?
    
    
    var pokemonArray: [Pokemon] = []  // declaring an array for Pokemon on tableview
    var limit = 30 // limit of sprites per page
    let totalEntries = 150 // upper limit of pokemon sprites
    var pokemonBatch: [Result] = []
    var nextURL: String = ""
    //        var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PokemonTableView.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "PokemonTableViewCell")
        self.PokemonTableView.dataSource = self
        self.PokemonTableView.delegate = self
        self.getThirtyPokemon() // Loadview, what displays on view controller
        //                self.getAllPokemon()
        self.getInitialData()
    }
    
    func getInitialData() {
        pokemonBatch = []
        nextURL = "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=30"
        getDataFromPokemon()
    }
    func getDataFromPokemon() {
        if isArrayFull() == false {
            guard let urlObj = URL(string: nextURL) else {return}
            URLSession.shared.dataTask(with: urlObj) {[weak self](data, response, error) in
                guard let data = data else {return}
                do {
                    let downloadedPokemon = try JSONDecoder().decode(PaginatedPokemon.self, from: data)
                    self?.pokemonBatch.append(contentsOf: downloadedPokemon.results)
                    self?.nextURL = downloadedPokemon.next
                    
                    DispatchQueue.main.async {
                        self?.PokemonTableView.reloadData()
                    }
                }
                catch {
                    print(error)
                }
            }
            .resume()
        }
    }
    
//        func createPokemonURL() -> String {
//            let apiLink = "https://pokeapi.co/api/v2/pokemon/"
//            return apiLink
//        }
    private func getThirtyPokemon(){
        self.PokemonTableView.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "PokemonTableViewCell")
        self.PokemonTableView.dataSource = self
        let group = DispatchGroup() // Dispatch Group  - displays 30 Pokemon at a time
        for _ in 1...151 {
            group.enter()
            NetworkingManager.shared.getDecodableObject(from: self.createPokemonURL()) {  (pokemon: Pokemon?, error) in
                guard let pokemon = pokemon else {return}
                self.pokemonArray.append(pokemon)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.PokemonTableView.reloadData()
        }
    }
    
    func isArrayFull() -> Bool {
        if pokemonBatch.count < totalEntries { return false}
        else {
            return true
        }
    }
    
    private func createPokemonURL () -> String {
        let randomNumber = Int.random(in: 1...151)
        return "https://pokeapi.co/api/v2/pokemon/\(randomNumber)"
    }
    
    private func generateAlert(from error: Error) -> UIAlertController {
        let alert = UIAlertController (
            title: "Error", message: "We ran into an error! Error Description: \(error.localizedDescription)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PokemonDetailsViewController {
            destination.pokemon = pokemonArray[PokemonTableView.indexPathForSelectedRow!.row]
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pokemonBatch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let count = pokemonBatch.count
        let lastElement = count - 1
        if indexPath.row == lastElement {
            getDataFromPokemon()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonTableViewCell", for: indexPath) as!
            PokemonTableViewCell
        cell.configure(with: self.pokemonArray[indexPath.row])
        return  cell
    }
    
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 44.0
        }
}
extension ViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastIndex = IndexPath(row: self.pokemonArray.count - 1, section: 0)
        guard indexPaths.contains(lastIndex) else {return}
        self.getThirtyPokemon() // infinite scrolling
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailsScreen", sender: self) // connects pokemon details viewcontroller with main view controller.
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //let lastIndexPath = indexPath.row
        if indexPath.row == pokemonArray.count - 1 {
            if pokemonArray.count < totalEntries {
                //self.getAllPokemon(pageNumber)
            }
        }
    }
}
