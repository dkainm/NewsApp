//
//  ApiManager.swift
//  NewsApp
//
//  Created by Alex Rudoi on 9/8/21.
//

import Alamofire
import SVProgressHUD

typealias articlesComplition = ([Article]) -> Void

class ApiManager {
    
    let mainUrl = "https://newsapi.org/v2/"
    let apiKey = "c06ee8d8208f4637a2cbc725315249a7"
    
    static var shared: ApiManager = {
        let instance = ApiManager()
        return instance
    }()
    
    private init(){}
    
    enum ArticleCategory: String {
        case relevancy = "relevancy"
        case popularity = "popularity"
        case publishedAt = "publishedAt"
    }
    
    func getArticles(keyword: String, sources: [String]?, country: String?, category: ArticleCategory?, complition: @escaping articlesComplition) {
        
        let url = mainUrl + "everything"
        
        var params: [String: Any] = [
            "apiKey": apiKey,
            "q": keyword
        ]
        
        if sources != nil {
            params["sources"] = getSourcesString(sources!)
        }
        if country != nil {
            params["country"] = country!
        }
        if category != nil {
            params["category"] = category!.rawValue
        }
        
        let manager = AF
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        SVProgressHUD.show()
        
        let request = manager.request(url, method: .get, parameters: params)
        request.responseDecodable(of: ArticlesResponce.self) { responce in
            switch responce.result {
            case .success(let value):
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    complition(value.articles)
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    print(err)
                    presentAlert(title: "Error", message: "\(err.localizedDescription)")
                }
            }
        }
    }
    
    private func getSourcesString(_ sources: [String]) -> String {
        var str = ""
        sources.forEach { word in
            str.append("\(word),")
            if word != sources.last { str.append(" ") }
        }
        
        return str
    }
    
}
