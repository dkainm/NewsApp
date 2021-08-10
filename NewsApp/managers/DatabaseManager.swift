//
//  DatabaseManager.swift
//  NewsApp
//
//  Created by Alex Rudoi on 9/8/21.
//

import RealmSwift
import Realm

class DatabaseManager {
    
    var realm = try! Realm()
    
    static var shared: DatabaseManager = {
        let instance = DatabaseManager()
        return instance
    }()
    
    private init(){}
    
    func getArticles() -> Results<ArticleObject> {
        return realm.objects(ArticleObject.self)
    }
    
    func addArticle(_ article: ArticleObject) {
        var allowToSave = true
        getArticles().forEach { object in
            if article.url == object.url {
                allowToSave = false
            }
        }
        
        if allowToSave {
            do {
                try realm.write { realm.add(article) }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteArticle(_ article: ArticleObject) {
        do {
            try realm.write { realm.delete(article) }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func clearDatabase() {
        getArticles().forEach { object in
            do {
                try realm.write { realm.delete(object) }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
