//
//  PokemonTableViewCell.swift
//  Pokemon
//
//  Created by Field Employee on 12/12/20.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    
    
   
    
    @IBOutlet weak var pokemonLabel: UILabel!
    
    
    @IBOutlet weak var pokemonImage: UIImageView!
    func configure(with pokemon: Pokemon) {
        self.pokemonLabel.text = pokemon.name
        NetworkingManager.shared.getImageData(from: pokemon.frontImageURL) { (data, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.pokemonImage.image = UIImage(data: data)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}




