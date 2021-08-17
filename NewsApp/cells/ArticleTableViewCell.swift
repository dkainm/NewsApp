//
//  ArticleTableViewCell.swift
//  NewsApp
//
//  Created by Alex Rudoi on 9/8/21.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    
    private var author = "" {
        didSet {
            self.authorLabel.text = "Author: " + self.author
            self.authorLabel.backgroundColor = .clear
        }
    }
    private var title = "" {
        didSet {
            self.titleLabel.text = self.title
            self.titleLabel.backgroundColor = .clear
        }
    }
    private var desc = "" {
        didSet {
            self.descriptionLabel.text = self.desc
            self.descriptionLabel.backgroundColor = .clear
        }
    }
    private var url = ""
    private var urlToImage = ""
    private var publishedAt = ""
    private var content = ""
    private var source = "" {
        didSet {
            self.sourceLabel.text = "Source: " + self.source
            self.sourceLabel.backgroundColor = .clear
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        descriptionLabel.text = ""
        articleImageView.image = nil
        sourceLabel.text = ""
        authorLabel.text = ""
    }
    
    func configure(article: Article?) {
        guard let article = article else { return }
        author = article.author
        title = article.title
        desc = article.desc
        url = article.url
        urlToImage = article.urlToImage
        publishedAt = article.publishedAt
        content = article.content
        source = article.source.name
    }
    
}
