//
//  MovieDetailCastCollectionViewCell.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 5.06.2022.
//

import UIKit

protocol NibLoadable {
    static func nib() -> UINib
    static var identifier: String { get }
}

class MovieDetailCastCollectionViewCell: UICollectionViewCell, NibLoadable {
    
    @IBOutlet var castImageView: UIImageView!
    @IBOutlet var castNameLabel: UILabel!
    @IBOutlet var characterNameLabel: UILabel!
    
    
    func castCollectionViewConfigure(cast: CastModel) {
        castNameLabel.text = cast.name
        characterNameLabel.text = cast.character

        castImageView.setImage("\(K.urls.imageBaseUrl)" + (cast.profilePath ?? ""), placeholder: "noImage")
    }

    static let identifier = "castCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieDetailCastCollectionViewCell", bundle: nil)
    }

}


