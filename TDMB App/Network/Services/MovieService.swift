//
//  MovieListService1.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 13.06.2022.
//

import Foundation
import UIKit

protocol MovieServicesProtocol {
    func getAllMovies(pageID: Int, completion: @escaping (Result<MoviesData, NetworkError>) -> Void)
    func getFilteredMovies(query: String, pageID: Int, completion: @escaping (Result<SearchRootModel, NetworkError>) -> Void)
}

protocol DetailServicesProtocol {
    func getMovieDetail(id: Int, completion: @escaping (Result<DetailData, NetworkError>) -> Void)
    func getCastDetail(personID: Int, completion: @escaping (Result<RootCastDetailModel, NetworkError>) -> Void)
    func getMovieLink(id: Int, completion: @escaping (Result<RootMovieWebLinkModel, NetworkError>) -> Void)
    func getMovieCast(id: Int, completion: @escaping (Result<RootCastModel, NetworkError>) -> Void)
    func getMovieRecom(id: Int, completion: @escaping (Result<MoviesData, NetworkError>) -> Void)
}

private let network = Network()

struct MovieServices: MovieServicesProtocol {
    
    func getAllMovies(pageID: Int = 1, completion: @escaping (Result<MoviesData, NetworkError>) -> Void) {
        if let url = urlComp.getAllMovies(pageID: pageID).url {
            let urlRequest = URLRequest(url: url)
            network.performRequest(request: urlRequest, completion: completion)
        } else {
            completion(.failure(.unknownError))
        }
        
    }
    
    func getFilteredMovies(query: String, pageID: Int, completion: @escaping (Result<SearchRootModel, NetworkError>) -> Void) {
        let newQuery:String = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if let url = urlComp.getFilteredMovies(pageID: pageID, query: newQuery).url {
            let urlRequest = URLRequest(url: url)
            network.performRequest(request: urlRequest, completion: completion)
        } else {
            completion(.failure(.unknownError))
        }
        
    }
    
}

struct DetailServices: DetailServicesProtocol {
    
    func getMovieDetail(id: Int, completion: @escaping (Result<DetailData, NetworkError>) -> Void) {
        if let url = urlComp.getMovieDetail(movieID: id).url {
            let urlRequest = URLRequest(url: url)
            network.performRequest(request: urlRequest, completion: completion)
        } else {
            completion(.failure(.unknownError))
        }
    }
    
    func getCastDetail(personID: Int, completion: @escaping (Result<RootCastDetailModel, NetworkError>) -> Void) {
        if let url = urlComp.getCastDetail(personID: personID).url {
            let urlRequest = URLRequest(url: url)
            network.performRequest(request: urlRequest, completion: completion)
        } else {
            completion(.failure(.unknownError))
        }
        
    }
    
    func getMovieLink(id: Int, completion: @escaping (Result<RootMovieWebLinkModel, NetworkError>) -> Void) {
        if let url = urlComp.getMovieLink(movieID: id).url {
            let urlRequest = URLRequest(url: url)
            network.performRequest(request: urlRequest, completion: completion)
        } else {
            completion(.failure(.unknownError))
        }
        
    }
    
    func getMovieCast(id: Int, completion: @escaping (Result<RootCastModel, NetworkError>) -> Void) {
        if let url = urlComp.getMovieCast(movieID: id).url {
            let urlRequest = URLRequest(url: url)
            network.performRequest(request: urlRequest, completion: completion)
        } else {
            completion(.failure(.unknownError))
        }
        
    }
    
    func getMovieRecom(id: Int, completion: @escaping (Result<MoviesData, NetworkError>) -> Void) {
        if let url = urlComp.getMovieRecom(movieID: id).url {
            let urlRequest = URLRequest(url: url)
            network.performRequest(request: urlRequest, completion: completion)
        } else {
            completion(.failure(.unknownError))
        }
        
    }
}











