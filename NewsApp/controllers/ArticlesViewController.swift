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
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        fetchData()
    }
    
    private func fetchData() {
        ApiManager.shared.getArticles(keyword: "Apple", sources: nil, country: nil, category: nil) { [weak self] result in
            self?.articles = result
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    //MARK: – Refresh Control
    
    @objc func refresh(_ sender: Any) {
        fetchData()
    }
    
    //MARK: – TableView Delegate & Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (articles.count == 0) ? 8 : articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "article", for: indexPath) as! ArticleTableViewCell
        var article: Any = ""
        if articles.count - 1 > indexPath.row {
            article = articles[indexPath.row]
        }
        cell.configure(article: article)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleWebViewController") as! ArticleWebViewController
        articleView.title = articles[indexPath.row].source.name
        articleView.urlString = articles[indexPath.row].url
        navigationController?.pushViewController(articleView, animated: true)
    }

}

