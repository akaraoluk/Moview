//
//  Network.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 10.06.2022.
//

import Foundation

struct Network {
    
    private let session = URLSession.shared
    
    func performRequest<T: Codable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let model = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(model))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                } else if error != nil {
                    completion(.failure(.networkError))
                } else {
                    completion(.failure(.unknownError))
                }
            }
        }
        task.resume()
    }
    
}

enum NetworkError: Error {
    
    case decodingError
    case networkError
    case unknownError
    
    var message: String {
        switch self {
        case .decodingError:
            return "Error Decoding"
        case .networkError:
            return "Error Network"
        case .unknownError:
            return "Error Unknown"
        }
    }
}
