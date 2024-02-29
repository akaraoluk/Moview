//
//  MovieDetailRecommendationsCollectionViewCell.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 5.06.2022.
//

import UIKit

class MovieDetailRecommendationsCollectionViewCell: UICollectionViewCell, NibLoadable {
    
    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var movieOriginalTitleLabel: UILabel!
    
    func recommendationsCollectionViewConfigure(recom: Movie) {
        movieOriginalTitleLabel.text = recom.original_title
        movieImageView.setImage("\(K.urls.imageBaseUrl)" + (recom.movieImage ?? ""), placeholder: "noImage")
    }
    
    
    static let identifier = "recommendationsCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieDetailRecommendationsCollectionViewCell", bundle: nil)
    }

}


