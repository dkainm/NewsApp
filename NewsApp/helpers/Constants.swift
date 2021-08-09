//
//  Constants.swift
//  NewsApp
//
//  Created by Alex Rudoi on 9/8/21.
//

import UIKit

public func topViewController() -> UIViewController {
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    
    var topController = keyWindow?.rootViewController!
    while let presentedViewController = topController?.presentedViewController {
        topController = presentedViewController
    }
    return topController!
}

public func presentAlert(title: String, message: String? = nil, actionName: String? = "OK", complition: (() -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alert.addAction(UIAlertAction(title: actionName, style: .default, handler: { _ in
        complition?()
    }))
    topViewController().present(alert, animated: true)
}
