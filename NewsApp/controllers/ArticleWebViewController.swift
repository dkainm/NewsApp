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
    @IBOutlet weak var progressView: UIProgressView!
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wkWebView.navigationDelegate = self
        wkWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        if let str = urlString {
            loadUrl(string: str)
        }
    }
    
    private func loadUrl(string urlString: String) {
        let url = URL(string: urlString)!
        wkWebView.load(URLRequest(url: url))
    }

    //MARK: – WebView Observer
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let progress = Float(wkWebView.estimatedProgress)
            progressView.setProgress(progress, animated: true)
            if progress == 1.0 {
                progressView.isHidden = true
            }
        }
    }
}
