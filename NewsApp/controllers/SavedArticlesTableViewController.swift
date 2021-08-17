//
//  SavedArticlesTableViewController.swift
//  NewsApp
//
//  Created by Alex Rudoi on 10/8/21.
//

import UIKit
import RealmSwift
import Nuke

class SavedArticlesTableViewController: MainTableViewController {
    
    var filteredArticles: [Article] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func setup() {
        super.setup()
        
        searchController.searchResultsUpdater = self
    }
    
    override func fetchData() {
        articles = DatabaseManager.shared
            .getArticles().toArray()
            .compactMap { $0.toArticle() }
        tableView.reloadData()
    }
    
    //MARK: – TableView Delegate & Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredArticles.count
        }
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "article", for: indexPath) as! ArticleTableViewCell
        
        let currentArticle = isFiltering ?
            filteredArticles[indexPath.row] : articles[indexPath.row]
        
        Nuke.loadImage(with: URL(string: currentArticle.urlToImage)!, options: nukeOptions, into: cell.articleImageView)
        cell.configure(article: currentArticle)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleWebViewController") as! ArticleWebViewController
        
        let currentArticle = isFiltering ?
            filteredArticles[indexPath.row] : articles[indexPath.row]
        
        articleView.title = currentArticle.source.name
        articleView.urlString = currentArticle.url
        navigationController?.pushViewController(articleView, animated: true)
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
    
    private func deleteArticle(_ article: Article) {
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
        filteredArticles = articles.filter {
            return $0.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
}
