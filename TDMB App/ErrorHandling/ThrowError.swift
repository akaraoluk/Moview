//
//  ThrowError.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 20.07.2022.
//

import Foundation

enum CustomError: Error {
    case noInternetConnection
    case noCastInformation
    case noLinkInformation
    case noAvailableWebsite
    case serverNotRespond
    case urlError
}
