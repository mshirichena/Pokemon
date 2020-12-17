//
//  PaginatedPokemon.swift
//  Pokemon
//
//  Created by Christian Shirichena on 12/16/20.
//

import Foundation

struct PaginatedPokemon: Decodable {
    let next: String
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case next
        case results
    }
}

struct Result: Decodable {
    let name: String
    let url: String
    
   
    enum ResultCodingKeys: String, CodingKey {
        case name
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultCodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(String.self, forKey: .url)
        
    }
}
