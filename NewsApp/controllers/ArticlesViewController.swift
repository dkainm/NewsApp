//
//  ViewController.swift
//  NewsApp
//
//  Created by Alex Rudoi on 9/8/21.
//

import UIKit
import Nuke

class ArticlesTableViewController: MainTableViewController {
    
    var keyword = "Apple"
    
    override func setup() {
        super.setup()
        searchController.searchBar.delegate = self
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    override func fetchData() {
        setViewToLoad()
        ApiManager.shared.getArticlesByKeyword(keyword, sources: nil, country: nil, category: nil) { [weak self] result in
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
    
    private func setViewToLoad() {
        articles = []
        tableView.reloadData()
    }
    
    @IBAction func filterTapped(_ sender: UIBarButtonItem) {
        let filterController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterTableViewController")
        present(filterController, animated: true)
    }
    
    //MARK: – TableView Delegate & Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.isEmpty ? 8 : articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "article", for: indexPath) as! ArticleTableViewCell
        if articles.count - 1 > indexPath.row {
            let currentArticle = articles[indexPath.row]
            Nuke.loadImage(with: URL(string: currentArticle.urlToImage)!, options: nukeOptions, into: cell.articleImageView)
            cell.configure(article: currentArticle)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !articles.isEmpty {
            let articleView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleWebViewController") as! ArticleWebViewController
            articleView.title = articles[indexPath.row].source.name
            articleView.urlString = articles[indexPath.row].url
            navigationController?.pushViewController(articleView, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let save = UIContextualAction(style: .normal, title: nil) { [weak self] (contexualAction, view, complitionHandler)  in
            let article = self?.articles[indexPath.row]
            self?.saveArticle(article!)
            complitionHandler(true)
        }
        save.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage.saveIcon?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        save.backgroundColor = .secondaryGreen
        
        let configuration = UISwipeActionsConfiguration(actions: [save])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
    
    private func saveArticle(_ article: Article) {
        let object = ArticleObject()
        object.author = article.author
        object.content = article.content
        object.desc = article.desc
        object.publishedAt = article.publishedAt
        object.title = article.title
        object.url = article.url
        object.urlToImage = article.urlToImage
        object.sourceName = article.source.name
        DatabaseManager.shared.addArticle(object)
    }
    
}

//MARK: – Search Controller Delegate

extension ArticlesTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        keyword = searchText
        fetchData()
    }
}

