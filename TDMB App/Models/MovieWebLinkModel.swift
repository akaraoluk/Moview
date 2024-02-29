//
//  MovieWebLinkModel.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 5.06.2022.
//

import Foundation

struct RootMovieWebLinkModel: Codable {
    
    var imdbID: String?
    var id: Int?
    
    enum CodingKeys: String, CodingKey {
        case imdbID = "imdb_id"
        case id
    }
    
}
