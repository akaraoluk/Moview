//
//  CastDetailViewController.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 5.06.2022.
//

import UIKit

class CastDetailViewController: UIViewController {
    
    @IBOutlet var castImageView: UIImageView!
    @IBOutlet var castNameLabel: UILabel!
    @IBOutlet var castPlaceOfBirthLabel: UILabel!
    @IBOutlet var castBirthdayDeathdayLabel: UILabel!
    @IBOutlet var castBiographyLabel: UILabel!
    @IBOutlet var deathdayLabel: UILabel!
    
    var personID: Int?
    private let castService = DetailServices()
    private var cast: RootCastDetailModel? {
        
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = personID {
            castService.getCastDetail(personID: id) { result in
                switch result {
                case .success(let cast):
                    self.cast = cast
                case.failure(let error):
                    print(error)
                }
            }
        } else {
            let alertVC = UIAlertController(title: "Error", message: "Cast Not Found", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .default) { action in
                self.navigationController?.popViewController(animated: true)
            }
            alertVC.addAction(okButton)
            self.present(alertVC, animated: true)
        }
        
    }
    
    func updateUI() {
        castNameLabel.text = cast?.name
        castBiographyLabel.text = cast?.biography
        castPlaceOfBirthLabel.text = cast?.placeOfBirth
        castBirthdayDeathdayLabel.text = String("\(cast?.birthday ?? "")")
        deathdayLabel.text = String(cast?.deathday ?? "")
        self.castImageView.setImage("\(K.urls.imageBaseUrl)" + (cast?.profilePath ?? ""), placeholder: "noImage")
    }
    
}

