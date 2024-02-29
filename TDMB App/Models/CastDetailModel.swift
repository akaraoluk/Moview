//
//  CastDetailModel.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 7.06.2022.
//

import Foundation

struct RootCastDetailModel: Codable {
    
    var birthday: String?
    var deathday: String?
    var id: Int?
    var name: String?
    var biography: String?
    var placeOfBirth, profilePath: String?

    enum CodingKeys: String, CodingKey {
        case birthday
        case deathday, id, name
        case biography
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
    }
    
}
