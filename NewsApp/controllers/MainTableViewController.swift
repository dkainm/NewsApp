//
//  MainTableViewController.swift
//  NewsApp
//
//  Created by Alex Rudoi on 13/8/21.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var articles: [Article] = []
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    func setup() {
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        
        tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "article")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
}
