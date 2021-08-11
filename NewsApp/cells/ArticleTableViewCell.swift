//
//  ArticleTableViewCell.swift
//  NewsApp
//
//  Created by Alex Rudoi on 9/8/21.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    var author = "" {
        didSet {
            self.authorLabel.text = "Author: " + self.author
            self.authorLabel.backgroundColor = .clear
        }
    }
    var title = "" {
        didSet {
            self.titleLabel.text = self.title
            self.titleLabel.backgroundColor = .clear
        }
    }
    var desc = "" {
        didSet {
            self.descriptionLabel.text = self.desc
            self.descriptionLabel.backgroundColor = .clear
        }
    }
    var url = ""
    var urlToImage = ""
    var publishedAt = ""
    var content = ""
    var source = "" {
        didSet {
            self.sourceLabel.text = "Source: " + self.source
            self.sourceLabel.backgroundColor = .clear
        }
    }
    
    func configure<T>(article: T) {
        if let a = article as? Article {
            author = a.author
            title = a.title
            desc = a.desc
            url = a.url
            urlToImage = a.urlToImage
            publishedAt = a.publishedAt
            content = a.content
            source = a.source.name
        } else if let a = article as? ArticleObject {
            author = a.author
            title = a.title
            desc = a.desc
            url = a.url
            urlToImage = a.urlToImage
            publishedAt = a.publishedAt
            content = a.content
            source = a.sourceName
        }
    }
    
}
