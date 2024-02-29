//
//  MovieWebViewController.swift
//  TDMB App
//
//  Created by Abdurrahman Karaoluk on 5.06.2022.
//

import UIKit
import WebKit

class MovieWebViewController: UIViewController {
    
    @IBOutlet var showMovieLinkWKWebView: WKWebView!
    
    var imdbLinkID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "\(K.urls.webBaseUrl)\(self.imdbLinkID)") {
            self.showMovieLinkWKWebView.load(URLRequest(url: url))
        } else {
            "noavailablewebsite"
        }
    }
    
}
