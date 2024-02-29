//
//  CastModel.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 5.06.2022.
//

import Foundation

struct RootCastModel: Codable {
    
    let id: Int?
    let cast: [CastModel]?

}

struct CastModel: Codable {
    
    let id: Int?
    let name: String?
    let profilePath: String?
    let character: String?
    
    private enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case profilePath = "profile_path"
        case character
        
    }

}

