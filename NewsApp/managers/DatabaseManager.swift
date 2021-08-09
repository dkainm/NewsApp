//
//  DatabaseManager.swift
//  NewsApp
//
//  Created by Alex Rudoi on 9/8/21.
//

import RealmSwift

class DatabaseManager {
    
    let realm = try! Realm()
    
    static var shared: DatabaseManager = {
        let instance = DatabaseManager()
        return instance
    }()
    
    private init(){}
    
    func getArticles() -> Results<ArticleObject> {
        return realm.objects(ArticleObject.self)
    }
    
    func addArticle(_ article: ArticleObject) {
        do {
            try realm.write { realm.add(article) }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteArticle(_ article: ArticleObject) {
        do {
            try realm.write { realm.delete(article) }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
