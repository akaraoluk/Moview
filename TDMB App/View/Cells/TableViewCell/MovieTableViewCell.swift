//
//  MovieTableViewCell.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 23.06.2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var movieNameLabel: UILabel!
    @IBOutlet var movieReleaseDateLabel: UILabel!
    @IBOutlet var movieRatingLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    var urlString: String = ""
    var favArray = [Int]()
    var movieID: Int?
    
    func favListTableViewConfigure(movie: DetailData) {
        if let posterPath = movie.posterPath {
            self.movieImageView?.setImage("\(K.urls.imageBaseUrl)" + posterPath, placeholder: "noImage")
        }

        if isFavoriteSymbol(id: movie.id!) == true {
                favoriteButton.setImage(UIImage(named: "favIconFill"), for: .normal)
        }
        movieNameLabel.text = movie.title
        movieReleaseDateLabel.text = movie.releaseDate
        let strRate:String = String(format: "%.1f", movie.voteAverage ?? "")
        movieRatingLabel.text = strRate
        movieID = movie.id
    }
    
    func movieListTableViewConfigure(movie: Movie) {
        if let imageUrl = movie.movieImage {
            self.movieImageView?.setImage("\(K.urls.imageBaseUrl)" + imageUrl, placeholder: "noImage")
        }
        
        if isFavoriteSymbol(id: movie.id!) == true {
                favoriteButton.setImage(UIImage(named: "favIconFill"), for: .normal)
        }
        
        movieNameLabel.text = movie.title
        movieReleaseDateLabel.text = movie.date
        let strRate:String = String(format: "%.1f", movie.rate ?? "")
        movieRatingLabel.text = strRate
        movieID = movie.id
    }
    
    func movieListTableViewFilteringConfigure(movie: SearchModel) {
        
        if let posterPath = movie.posterPath {
            self.movieImageView?.setImage("\(K.urls.imageBaseUrl)" + posterPath, placeholder: "noImage")
        }
        
        if isFavoriteSymbol(id: movie.id!) == true {
                favoriteButton.setImage(UIImage(named: "favIconFill"), for: .normal)
        }
        
        movieNameLabel.text = movie.originalTitle
        movieReleaseDateLabel.text = movie.releaseDate
        let strRate:String = String(format: "%.1f", movie.voteAverage ?? "N/A")
        movieRatingLabel.text = strRate
        movieID = movie.id
    }
    
    func isFavoriteSymbol(id: Int) -> Bool {
        if let favs = UserDefaults.standard.object(forKey: "id") as? [Int] {
            if favs.contains(id) {
                return true
            }
        }
        return false
    }

    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        let dataManager = DataManager()

        if let id = movieID {

            dataManager.saveOrRemove(id: id, button: favoriteButton)

            NotificationCenter.default.post(name: Notification.Name("favChanged"), object: nil)
        }
        
        
        
    }
    
    override func prepareForReuse() {
            // invoke superclass implementation
            super.prepareForReuse()
            
            // reset (hide) the checkmark label
            favoriteButton.setImage(UIImage(named: "favIcon"), for: .normal)
        movieNameLabel.text = ""
        movieReleaseDateLabel.text = ""
     //   movieRatingLabel.text = ""
            
        }
    
}
