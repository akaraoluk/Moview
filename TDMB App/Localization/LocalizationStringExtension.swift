//
//  LocalizationStringExtension.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 24.06.2022.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
