//
//  RealmModels.swift
//  NewsApp
//
//  Created by Alex Rudoi on 9/8/21.
//

import RealmSwift
 
class ArticleObject: Object {
    @objc dynamic var sourceName = ""
    @objc dynamic var author = ""
    @objc dynamic var title = ""
    @objc dynamic var desc = ""
    @objc dynamic var url = ""
    @objc dynamic var urlToImage = ""
    @objc dynamic var publishedAt = ""
    @objc dynamic var content = ""
    
    func toArticle() -> Article {
        return Article(source: ArticleSource(id: nil, name: sourceName),
                       author: author,
                       title: title,
                       desc: desc,
                       url: url,
                       urlToImage: urlToImage,
                       publishedAt: publishedAt,
                       content: content)
    }
}
