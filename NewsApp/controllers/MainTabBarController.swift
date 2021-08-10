//
//  MainTabBarController.swift
//  NewsApp
//
//  Created by Alex Rudoi on 10/8/21.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        let articlesView = mainStoryboard.instantiateViewController(withIdentifier: "articlesNavigation")
        let savedArticlesView = mainStoryboard.instantiateViewController(withIdentifier: "savedArticlesNavigation")
        
        articlesView.tabBarItem = UITabBarItem(title: "News", image: .newsIcon, tag: 0)
        savedArticlesView.tabBarItem = UITabBarItem(title: "Saved", image: .saveIcon, tag: 1)
        
        viewControllers = [articlesView, savedArticlesView]
        setViewControllers(viewControllers, animated: true)
    }
    
}
