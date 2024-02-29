//
//  DataModel.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 31.05.2022.
//

import Foundation
 
struct MoviesData: Codable {
    
    let movies: [Movie]?
    let totalResults: Int?
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    
    let id: Int?
    let title: String?
    let date: String?
    let rate: Double?
    let movieImage: String?
    let budget: Int?
    let overview: String?
    let original_title: String?
    let revenue: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id, title, budget, overview, original_title, revenue
        case date = "release_date"
        case rate = "vote_average"
        case movieImage = "poster_path"
    }
    
}

