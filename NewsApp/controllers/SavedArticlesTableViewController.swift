//
//  SavedArticlesTableViewController.swift
//  NewsApp
//
//  Created by Alex Rudoi on 10/8/21.
//

import UIKit
import RealmSwift

class SavedArticlesTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var articles: Results<ArticleObject>!
    var filteredArticles: [ArticleObject] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        fetchData()
    }
    
    private func setup() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        
        tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "article")
    }
    
    private func fetchData() {
        articles = DatabaseManager.shared.getArticles()
        tableView.reloadData()
    }
    
    //MARK: – TableView Delegate & Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredArticles.count
        }
        return articles == nil ? 8 : articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "article", for: indexPath) as! ArticleTableViewCell
        
        let article: ArticleObject
        if isFiltering {
            article = filteredArticles[indexPath.row]
        } else {
            article = articles[indexPath.row]
        }
        
        cell.articleImageView.setDownloadedImage(from: article.urlToImage)
        cell.configure(article: article)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if articles != nil {
            let articleView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleWebViewController") as! ArticleWebViewController
            
            let article: ArticleObject
            if isFiltering {
                article = filteredArticles[indexPath.row]
            } else {
                article = articles[indexPath.row]
            }
            
            articleView.title = article.sourceName
            articleView.urlString = article.url
            navigationController?.pushViewController(articleView, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: nil) { [weak self] (contexualAction, view, complitionHandler)  in
            let article = self?.articles[indexPath.row]
            self?.deleteArticle(article!)
            complitionHandler(true)
        }
        delete.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage.trash?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        delete.backgroundColor = .secondaryRed
        
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
    
    private func deleteArticle(_ article: ArticleObject) {
        DatabaseManager.shared.deleteArticle(article)
        fetchData()
    }
    
}

//MARK: – Search Controller Results Updating

extension SavedArticlesTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredArticles = DatabaseManager.shared.getArticles().filter { (article: ArticleObject) -> Bool in
            return article.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
}
