//
//  GetLanguage.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 28.06.2022.
//

import Foundation

func getLanguage() -> String {
    let localeLanguage = Locale.current.languageCode!
    
    switch localeLanguage {
        
    case "tr":
        return "tr"
    case "fr":
        return "fr"

    default:
        return "en-US"
    }
}


