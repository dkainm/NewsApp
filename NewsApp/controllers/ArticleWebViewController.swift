//
//  ArticleWebViewController.swift
//  NewsApp
//
//  Created by Alex Rudoi on 9/8/21.
//

import UIKit
import WebKit

class ArticleWebViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var wkWebView: WKWebView!
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wkWebView.navigationDelegate = self
        if let str = urlString {
            loadUrl(string: str)
        }
    }
    
    private func loadUrl(string urlString: String) {
        let url = URL(string: urlString)!
        wkWebView.load(URLRequest(url: url))
    }
    
}
