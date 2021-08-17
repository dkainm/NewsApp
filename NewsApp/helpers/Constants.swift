//
//  Constants.swift
//  NewsApp
//
//  Created by Alex Rudoi on 9/8/21.
//

import UIKit
import Nuke

public let userDefaults = UserDefaults.standard

let nukeOptions = ImageLoadingOptions(
    transition: .fadeIn(duration: 0.33),
    contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center))

public func setUserDefaults() {
    if userDefaults.string(forKey: userCountry) == nil {
        userDefaults.set(getCountry(byCode: Locale.current.regionCode ?? "US"), forKey: userCountry)
    }
}

public func topViewController() -> UIViewController {
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    
    var topController = keyWindow?.rootViewController!
    while let presentedViewController = topController?.presentedViewController {
        topController = presentedViewController
    }
    return topController!
}

public func presentAlert(title: String, message: String? = nil, actionName: String? = "OK", cancelAction: Bool? = true, complition: (() -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    if cancelAction! {
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    }
    alert.addAction(UIAlertAction(title: actionName, style: .default, handler: { _ in
        complition?()
    }))
    topViewController().present(alert, animated: true)
}

public func countriesArray() -> [String] {
    var countries: [String] = []
    
    for code in NSLocale.isoCountryCodes  {
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
        let name = NSLocale(localeIdentifier: "us_US").displayName(forKey: NSLocale.Key.identifier, value: id)!
        countries.append(name)
    }
    
    return countries
}

public func getCountry(byCode code: String) -> String {
    let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
    let name = NSLocale(localeIdentifier: code).displayName(forKey: NSLocale.Key.identifier, value: id)!
    return name
}

public func getCountryCode(country: String) -> String {
    let locales: String = ""
    for localeCode in NSLocale.isoCountryCodes {
        let identifier = NSLocale(localeIdentifier: localeCode)
        let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
        if country.lowercased() == countryName?.lowercased() {
            return localeCode
        }
    }
    return locales
}
