//
//  DataManager.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 3.07.2022.
//

import Foundation
import UIKit

class DataManager {
    
    var favoriteArray = [Int]()
    private let defaults = UserDefaults.standard
    private let keyMovieID = "id"
    
    func getMovieArray() -> [Int] {
        var data = defaults.object(forKey: keyMovieID) as? [Int]
        return data ?? []
    }
    
    func saveOrRemove(id: Int, button: UIButton?) {
        favoriteArray = getMovieArray()
        if favoriteArray.contains(id) {
            if let index = favoriteArray.firstIndex(of: id) {
                favoriteArray.remove(at: index)
                defaults.set(favoriteArray, forKey: keyMovieID)
                if let button = button {
                    button.setImage(UIImage(named: "favIcon"), for: .normal)
                }
                
            }
        } else {
            favoriteArray.append(id)
            defaults.set(self.favoriteArray, forKey: keyMovieID)
            if let button = button {
                button.setImage(UIImage(named: "favIconFill"), for: .normal)
            }
        }
    }
    
    func contains(id: Int) -> Bool {
        return getMovieArray().contains(id)
    }
    
}



