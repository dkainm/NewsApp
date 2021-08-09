//
//  ViewController.swift
//  NewsApp
//
//  Created by Alex Rudoi on 9/8/21.
//

import UIKit

class ArticlesTableViewController: UITableViewController {

    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "article")
        ApiManager.shared.getArticles(keyword: "Apple", sources: nil, country: nil, category: nil) { [weak self] result in
            self?.articles = result
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK: – TableView Delegate & Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "article", for: indexPath) as! ArticleTableViewCell
        cell.configure(article: articles[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

}

