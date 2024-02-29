//
//  ViewController.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 31.05.2022.
//

import UIKit
import SwiftUI

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var movieSearchBar: UISearchBar! {
        didSet {
            movieSearchBar.delegate = self
        }
    }
    @IBOutlet var movieListTableView: UITableView! {
        didSet {
            movieListTableView.delegate = self
            movieListTableView.dataSource = self
            movieListTableView.register(UINib(nibName: String(describing: MovieTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MovieTableViewCell.self))
        }
    }
    
    var popularMovies = [Movie]()
    var filteredMovies = [SearchModel]()
    var searchBarText = ""
    var filteredTotal = 0
    var popularTotal = 0
    var dataTask: URLSessionTask?
    var detailId: Int?
    var pageID: Int = 1
    var pageIDSearch: Int = 1
    var isFiltering = false
    var isFinish = true
    var searchTask: DispatchWorkItem?
    
    private let movieListService = MovieServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Popular Movies".localized()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived), name: Notification.Name("favChanged"), object: nil)
        
        movieListService.getAllMovies { result in
            switch result{
            case .success(let response):
                self.popularMovies = response.movies ?? []
                self.popularTotal = response.totalResults ?? 0
                self.movieListTableView.reloadData()
                self.pageID += 1
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering == false {
            return self.popularMovies.count
        } else {//Tek array
            if filteredMovies.count == 0 {
                self.movieListTableView.setEmptyMessage("No suitable movie found, please try a different name.")
            }else {
                movieListTableView.restore()
            }
            return self.filteredMovies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self), for: indexPath) as! MovieTableViewCell
        if isFiltering == false {
            cell.movieListTableViewConfigure(movie: popularMovies[indexPath.row])
        } else {
            cell.movieListTableViewFilteringConfigure(movie: filteredMovies[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering == false {
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController {
                detailVC.id = popularMovies[indexPath.row].id
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        } else {
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController {
                detailVC.id = filteredMovies[indexPath.row].id
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
}

extension MovieListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTask?.cancel()
        filteredMovies = []
        if searchText == "" {
            self.isFiltering = false
            
            self.movieListTableView.reloadData()
        }
        else {
            self.isFiltering = true
            let task = DispatchWorkItem {
                self.movieListService.getFilteredMovies(query: searchText, pageID: self.pageIDSearch) { result in
                    switch result{
                    case .success(let response):
                        self.searchBarText = searchText
                        self.filteredMovies = response.results!
                        self.filteredTotal = Int(response.totalResults!)
                        self.movieListTableView.reloadData()
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            self.searchTask = task
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == filteredMovies.count - 2 && isFiltering == true && isFinish{
            self.movieListTableView.tableFooterView = createSpinenFooter()
            if filteredMovies.count < filteredTotal {
                //isfinish false
                movieListService.getFilteredMovies(query: searchBarText, pageID: self.pageIDSearch) { result in
                    switch result{
                    case .success(let response):
                        self.isFinish = false
                        self.pageIDSearch += 1
                        self.filteredMovies.append(contentsOf: response.results!)
                        self.filteredTotal = response.totalResults!
                        
                        self.movieListTableView.reloadData()
                        self.isFinish = true
                    case .failure(let error):
                        print(error)
                    }
                    DispatchQueue.main.async {
                        self.movieListTableView.tableFooterView = nil
                    }
                }
            }
        } else if (indexPath.row == (popularMovies.count - 2)) && (isFiltering == false) && (isFinish) {
            self.movieListTableView.tableFooterView = createSpinenFooter()
            if popularMovies.count < self.popularTotal {
                movieListService.getAllMovies(pageID: self.pageID) { result in
                    switch result{
                    case .success(let response):
                        self.isFinish = false
                        self.pageID += 1
                        self.popularMovies.append(contentsOf: response.movies ?? [])
                        self.filteredTotal = response.totalResults ?? 0
                        self.movieListTableView.reloadData()
                        self.isFinish = true
                    case .failure(let error):
                        print(error)
                    }
                    DispatchQueue.main.async {
                        self.movieListTableView.tableFooterView = nil
                    }
                    
                }
            }
        }
        
    }
    
    @objc func notificationReceived() {
        movieListTableView.reloadData()
    }
    
}

private func createSpinenFooter() -> UIView {
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
    let spinner = UIActivityIndicatorView()
    spinner.center = footerView.center
    footerView.addSubview(spinner)
    spinner.startAnimating()
    return footerView
}



