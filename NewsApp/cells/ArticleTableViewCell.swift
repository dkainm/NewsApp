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
    
    var author = ""
    var title = ""
    var desc = ""
    var url = ""
    var urlToImage = ""
    var publishedAt = ""
    var content = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
            articleImageView.setDownloadedImage(from: a.urlToImage) {
                self.titleLabel.text = self.title
                self.titleLabel.backgroundColor = .clear
                self.descriptionLabel.text = self.desc
                self.descriptionLabel.backgroundColor = .clear
            }
        } else if let a = article as? ArticleObject {
            author = a.author
            title = a.title
            desc = a.desc
            url = a.url
            urlToImage = a.urlToImage
            publishedAt = a.publishedAt
            content = a.content
            articleImageView.setDownloadedImage(from: a.urlToImage) {
                self.titleLabel.text = self.title
                self.titleLabel.backgroundColor = .clear
                self.descriptionLabel.text = self.desc
                self.descriptionLabel.backgroundColor = .clear
            }
        }
    }
    
}
