//
//  NetworkModels.swift
//  NewsApp
//
//  Created by Alex Rudoi on 9/8/21.
//

struct ArticlesResponce: Decodable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}

struct Article: Decodable {
    var source: ArticleSource
    var author: String
    var title: String
    var desc: String
    var url: String
    var urlToImage: String
    var publishedAt: String
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case desc = "description"
        case url
        case urlToImage
        case publishedAt
        case content
    }
}

struct ArticleSource: Decodable {
    var id: String?
    var name: String
}
