//
//  ViewController.swift
//  NewsApp
//
//  Created by Alex Rudoi on 9/8/21.
//

import UIKit

class ArticlesTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var keyword = "Apple"
    var articles: [Article] = []
    
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
        definesPresentationContext = true
        
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "article")
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func fetchData() {
        setViewToLoad()
        ApiManager.shared.getArticles(keyword: keyword, sources: nil, country: nil, category: nil) { [weak self] result in
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
    
    //MARK: – TableView Delegate & Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.isEmpty ? 8 : articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "article", for: indexPath) as! ArticleTableViewCell
        var article: Any = ""
        if articles.count - 1 > indexPath.row {
            article = articles[indexPath.row]
            cell.articleImageView.setDownloadedImage(from: (article as! Article).urlToImage)
            cell.configure(article: article)
        }
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 85
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !articles.isEmpty {
            let articleView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleWebViewController") as! ArticleWebViewController
            articleView.title = articles[indexPath.row].source.name
            articleView.urlString = articles[indexPath.row].url
            navigationController?.pushViewController(articleView, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let save = UIContextualAction(style: .normal, title: nil) { [weak self] (contexualAction, view, nil)  in
            let article = self?.articles[indexPath.row]
            self?.saveArticle(article!)
        }
        save.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage.saveIcon?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        save.backgroundColor = .secondaryGreen
        
        return UISwipeActionsConfiguration(actions: [save])
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

