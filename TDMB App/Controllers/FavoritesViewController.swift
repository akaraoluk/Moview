//
//  FavoritesViewController.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 3.06.2022.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var favoriteMoviesTableView: UITableView! {
        didSet {
            favoriteMoviesTableView.delegate = self
            favoriteMoviesTableView.dataSource = self
            favoriteMoviesTableView.register(UINib(nibName: String(describing: MovieTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MovieTableViewCell.self))
            
        }
    }
    
    var favoriteMovies = [DetailData]()
    var favoritedMoviesIDArray = [Int]()
    var isFinishFetchData = false
    
    private let getMovieService = MovieServices()
    private let getDetailService = DetailServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Favorites".localized()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived), name: Notification.Name("favChanged"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var favs = UserDefaults.standard.object(forKey: "id") as? [Int]
        favoritedMoviesIDArray = favs ?? []
        favoriteMoviesTableView.isHidden = true
        super.viewWillAppear(animated)
        getData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let loader = self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.isFinishFetchData == true {
                self.stopLoader(loader: loader)
                self.favoriteMoviesTableView.isHidden = false
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if favoriteMovies.count == 0 {
            self.favoriteMoviesTableView.setEmptyMessage("No suitable movie found, please try a different name.")
        }else {
            favoriteMoviesTableView.restore()
        }
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self), for: indexPath) as! MovieTableViewCell
        cell.favListTableViewConfigure(movie: favoriteMovies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController {
            detailVC.id = favoriteMovies[indexPath.row].id
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func getData() {
        self.favoriteMovies.removeAll(keepingCapacity: true)
        for item in favoritedMoviesIDArray {
            self.getDetailService.getMovieDetail(id: item) { result in
                switch result {
                case .success(let fav):
                    self.favoriteMovies.append(fav)
                    //Hepsi geldikten sonra gelen kadar animasyon
                    self.favoriteMoviesTableView.reloadData()
                case .failure(let error):
                    print("favMovies get req error \(error)")
                }
            }
        }
        isFinishFetchData = true
        self.favoriteMoviesTableView.reloadData()
    }
    
    @objc func notificationReceived() {
        var favs = UserDefaults.standard.object(forKey: "id") as? [Int]
        favoritedMoviesIDArray = favs ?? []
        favoriteMoviesTableView.reloadData()
        self.getData()
    }
    
}





