//
//  PokemonDetailsViewController.swift
//  Pokemon
//
//  Created by Field Employee on 12/14/20.
//

import UIKit

class PokemonDetailsViewController: UIViewController {
    
    @IBOutlet weak var PokemonDetailsImage: UIImageView!
        
    @IBOutlet weak var PokemonDetailsLabel: UILabel!
    
        var pokemon: Pokemon?

        override func viewDidLoad() {
            
            super.viewDidLoad()
            
            PokemonDetailsLabel.text = pokemon?.name
            NetworkingManager.shared.getImageData(from: pokemon!.frontImageURL) { (data, error) in
                guard let data = data else {return}
                DispatchQueue.main.async { // Dispatch queue asychroniusly loads details view, showing more details regarding sprite images.
                    self.PokemonDetailsImage.image = UIImage(data: data)
                }
                
            }
        }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
