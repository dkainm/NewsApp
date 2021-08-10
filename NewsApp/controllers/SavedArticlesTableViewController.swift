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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        fetchData()
    }
    
    private func setup() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
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
        return articles == nil ? 8 : articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "article", for: indexPath) as! ArticleTableViewCell
        let article = articles[indexPath.row]
        cell.articleImageView.setDownloadedImage(from: article.urlToImage)
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
        if articles != nil {
            let articleView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleWebViewController") as! ArticleWebViewController
            articleView.title = articles[indexPath.row].sourceName
            articleView.urlString = articles[indexPath.row].url
            navigationController?.pushViewController(articleView, animated: true)
        }
    }
    
}

//MARK: – Search Controller Delegate

extension SavedArticlesTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
//        keyword = searchText
        fetchData()
    }
    
}
