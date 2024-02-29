//
//  MovieDetailViewController.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 4.06.2022.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var originalTitleLabel: UILabel!
    @IBOutlet var budgetLabel: UILabel!
    @IBOutlet var revenueLabel: UILabel!
    @IBOutlet var movieReleaseDateLabel: UILabel!
    @IBOutlet var runtimeLabel: UILabel!
    @IBOutlet var genresLabel: UILabel!
    @IBOutlet var originalLanguageLabel: UILabel!
    @IBOutlet var productionCompaniesLabel: UILabel!
    @IBOutlet var recommendationsTextLabel: UILabel!
    @IBOutlet var castTextLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    @IBOutlet var budgetRevenueUIView: UIView!
    @IBOutlet var overviewUIView: UIView!
    @IBOutlet var recommendationsLabelUIview: UIView!
    @IBOutlet var recommendationsUIView: UIView!
    @IBOutlet var castLabelUIView: UIView!
    @IBOutlet var castUIView: UIView!
    @IBOutlet var companiesUIView: UIView!
    @IBOutlet var genresUIView: UIView!
    @IBOutlet var releaseDateUIView: UIView!
    @IBOutlet var originalLanguageUIView: UIView!
    @IBOutlet var runTimeUIView: UIView!
    
   
    
    @IBOutlet var recommendationsCollectionView: UICollectionView! {
        didSet {
            recommendationsCollectionView.delegate = self
            recommendationsCollectionView.dataSource = self
            //  recommendationsCollectionView.collectionViewLayout = UICollectionViewLayout()
            recommendationsCollectionView.register(MovieDetailRecommendationsCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieDetailRecommendationsCollectionViewCell.identifier)
        }
    }
    @IBOutlet var castCollectionView: UICollectionView! {
        didSet {
            
            castCollectionView.dataSource = self
            castCollectionView.delegate = self
            // castCollectionView.collectionViewLayout = UICollectionViewLayout()
            castCollectionView.register(MovieDetailCastCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieDetailCastCollectionViewCell.identifier)
        }
    }
    
    var id: Int?
    var personID: Int?
    var moviesDataModel: DetailData?
    var recomModel: [Movie] = []
    var castModel: [CastModel] = []
    var imdbLinkID: String?
    var webLinkModel: RootMovieWebLinkModel?
    var dataManager = DataManager()
    
    private let movieServices = MovieServices()
    private let detailServices = DetailServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived), name: Notification.Name("favChanged"), object: nil)
        
        if let id = id {
            self.detailServices.getMovieDetail(id: id) { result in
                switch result {
                case .success(let detail):
                    self.moviesDataModel = detail
                    //MEtodlara bölünecek
                    
                    // MARK: - Recommendations
                    self.detailServices.getMovieRecom(id: self.id!) { result in
                        switch result {
                        case .success(let recoms):
                            self.recomModel = recoms.movies ?? []
                            if self.recomModel.isEmpty {
                                self.recommendationsUIView.isHidden = true
                            } else {
                                self.recommendationsUIView.isHidden = false
                                self.recommendationsCollectionView.reloadData()
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    
                    // MARK: - Cast
                    if let castMovieId = self.id {
                        self.detailServices.getMovieCast(id: castMovieId) { result in
                            switch result {
                            case.success(let cast):
                                self.castModel = cast.cast ?? []
                                if self.castModel.isEmpty {
                                    self.castUIView.isHidden = true
                                } else {
                                    self.castUIView.isHidden = false
                                    self.castCollectionView.reloadData()
                                }
                            case.failure(let error):
                                print(error)
                                Alert.showBasic(title: "ok", message: error.message, vc: self)
                            }
                        }
                    } else {
                       
                    }
                    
                    // MARK: - Link
                    if let movieId = self.id {
                        self.detailServices.getMovieLink(id: movieId) { result in
                            switch result {
                            case.success(let movieDet):
                                self.webLinkModel = movieDet
                            case.failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    } else {
                        print("Link not found")
                    }
                    self.setData()
                    
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        if let movieWebsite = moviesDataModel?.homepage {
            if movieWebsite != "" {
                let objectsToShare = [movieWebsite]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = sender
                self.present(activityVC, animated: true, completion: nil)
            } else {
                alert(message: LocalizationStrings.noExistForDeviceLanguage, title: LocalizationStrings.websiteNotFound)
            }
        } else {
            alert(message: LocalizationStrings.noExistForDeviceLanguage, title: LocalizationStrings.websiteNotFound)
        }
    }
    
    func setData() {
        if moviesDataModel?.originalTitle == moviesDataModel?.title {
            self.originalTitleLabel.text = self.moviesDataModel?.originalTitle
        } else {
            let orTit = String(moviesDataModel?.originalTitle ?? "")
            let tit = String(moviesDataModel?.title ?? "")
            self.originalTitleLabel.text = orTit + " (" + tit + ")"
        }
        
        if let overview = self.moviesDataModel?.overview, overview != "" {
            overviewLabel.text = overview
        } else {
            overviewUIView.isHidden = true
        }
        
        if let budget = self.moviesDataModel?.budget, budget != 0 {
            self.budgetLabel.text = LocalizationStrings.budget + (budget.formattedWithSeparator ) + "$"
        } else {
            budgetRevenueUIView.isHidden = true
        }
        
        if let revenue = self.moviesDataModel?.revenue, revenue != 0 {
            self.revenueLabel.text = LocalizationStrings.revenue + (revenue.formattedWithSeparator ) + "$"
        } else {
            budgetRevenueUIView.isHidden = true
        }
        
        if let movieID = id {
            if dataManager.contains(id: movieID) {
                favoriteButton.setImage(UIImage(named: "favIconFill"), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(named: "favIcon"), for: .normal)
            }
        }
        
        if let releaseDate = self.moviesDataModel?.releaseDate, releaseDate != "" {
            self.movieReleaseDateLabel.text = releaseDate
        } else {
            releaseDateUIView.isHidden = true
        }
        
        if let runTime: Int = self.moviesDataModel?.runtime {
            self.runtimeLabel.text = String(runTime) + LocalizationStrings.mins
        } else {
            runTimeUIView.isHidden = true
        }
        
        if let originalLanguage = self.moviesDataModel?.originalLanguage {
            self.originalLanguageLabel.text = originalLanguage.uppercased()
        }  else {
            originalLanguageUIView.isHidden = true
        }
        
        self.recommendationsTextLabel.text = LocalizationStrings.recommendations
        self.castTextLabel.text = LocalizationStrings.cast
        
        if let genres = self.moviesDataModel?.genres {
            var genstr = [String]()
            for i in genres {
                genstr.append(i.name ?? "")
            }
            let nameString = genstr.joined(separator: "-")
            self.genresLabel.text = nameString
        } else {
            genresUIView.isHidden = true
        }
        
        if let companies = self.moviesDataModel?.productionCompanies {
            var compStr = [String]()
            for i in companies {
                compStr.append(i.name ?? "")
            }
            let companiesString = compStr.joined(separator: "-")
            self.productionCompaniesLabel.text = LocalizationStrings.companies + companiesString
        } else {
            companiesUIView.isHidden = true
        }
        
        if let posterPath = self.moviesDataModel?.posterPath {
            self.imageView.setImage("\(K.urls.imageBaseUrl)" + posterPath, placeholder: "noImage")
        }
        
    }
    
    @objc func notificationReceived() {
        if let movieID = id {
            if dataManager.contains(id: movieID) {
                favoriteButton.setImage(UIImage(named: "favIconFill"), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(named: "favIcon"), for: .normal)
            }
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        if let movieID = id {
            dataManager.saveOrRemove(id: movieID, button: favoriteButton)
        }
        NotificationCenter.default.post(name: Notification.Name("favChanged"), object: nil)
    }
    
}
// MARK: - MovieDetailViewController CollectionViews
extension MovieDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let _ = collectionView.cellForItem(at: indexPath) as? MovieDetailRecommendationsCollectionViewCell {
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController {
                detailVC.id = recomModel[indexPath.row].id
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
        if let _ = collectionView.cellForItem(at: indexPath) as? MovieDetailCastCollectionViewCell {
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: CastDetailViewController.self)) as? CastDetailViewController {
                detailVC.personID = castModel[indexPath.row].id
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
        
    }
    
}

extension MovieDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.recommendationsCollectionView {
            return recomModel.count
        } else if collectionView == self.castCollectionView {
            return castModel.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.recommendationsCollectionView {
            let cell1 = recommendationsCollectionView.dequeueReusableCell(withReuseIdentifier: "recommendationsCollectionViewCell", for: indexPath) as! MovieDetailRecommendationsCollectionViewCell
            cell1.recommendationsCollectionViewConfigure(recom: recomModel[indexPath.row])
            return cell1
        } else if collectionView == self.castCollectionView {
            let cell2 = castCollectionView.dequeueReusableCell(withReuseIdentifier: "castCollectionViewCell", for: indexPath) as! MovieDetailCastCollectionViewCell
            cell2.castCollectionViewConfigure(cast: castModel[indexPath.row])
            return cell2
        }
        return UICollectionViewCell()
    }
    
    @IBAction func showPageTapped(_ sender: UIButton) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieWebViewController.self)) as? MovieWebViewController {
            detailVC.imdbLinkID = webLinkModel?.imdbID
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
    
}

//extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //        if collectionView == self.recommendationsCollectionView {
//        //            return CGSize(width: 200, height: 300)
//        //
//        //        } else if collectionView == self.castCollectionView {
//        //
//        //
//        //            return CGSize(width: 200, height: 300)
//        //
//        //        }
//        return CGSize(width: 200, height: 300)
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5.0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5.0
//    }
//
//}

