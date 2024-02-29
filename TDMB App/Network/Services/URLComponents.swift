//
//  URLComponents.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 4.07.2022.
//

import Foundation

enum urlComp {
    
    case getAllMovies(pageID: Int)
    case getMovieDetail(movieID: Int)
    case getCastDetail(personID: Int)
    case getMovieLink(movieID: Int)
    case getMovieCast(movieID: Int)
    case getMovieRecom(movieID: Int)
    case getFilteredMovies(pageID: Int, query: String)
    
    var url: URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3" + path
        urlComponents.queryItems = service()
        return urlComponents.url
    }
    
    private func service() -> [URLQueryItem]? {
        
        let queryItemApiKey = URLQueryItem(name: "api_key", value: "fe904076943b205d7d76d8f5ce1ffb67")
        let queryItemLanguage = URLQueryItem(name: "language", value: getLanguage())
        let queryItemIncludeAdult = URLQueryItem(name: "include_adult", value: "false")
        
        switch self {
        case .getAllMovies(let page):
            return [queryItemApiKey, queryItemLanguage, URLQueryItem(name: "page", value: page.description)]
        case .getMovieDetail:
            return [queryItemApiKey, queryItemLanguage]
        case .getCastDetail:
            return [queryItemApiKey, queryItemLanguage]
        case .getMovieLink:
            return [queryItemApiKey, queryItemLanguage]
        case .getMovieCast:
            return [queryItemApiKey, queryItemLanguage]
        case .getMovieRecom:
            return [queryItemApiKey, queryItemLanguage]
        case .getFilteredMovies(let page, let query):
             return [
                URLQueryItem(name: "query", value: String(query)),
                URLQueryItem(name: "page", value: page.description),
                queryItemApiKey,
                queryItemLanguage,
                queryItemIncludeAdult
            ]
        }
    }
      
}

extension urlComp {
    fileprivate var path: String {
        switch self {
        case .getAllMovies:
            return "/movie/popular"
        case .getMovieDetail(let movieID):
            return "/movie/\(movieID)"
        case .getCastDetail(let personID):
            return "/person/\(personID)"
        case .getMovieLink(let movieID):
            return "/movie/\(movieID)/external_ids"
        case .getMovieCast(let movieID):
            return "/movie/\(movieID)/credits"
        case .getMovieRecom(let movieID):
            return "/movie/\(movieID)/recommendations"
        case .getFilteredMovies:
            return "/search/movie"
        }
    }
}




