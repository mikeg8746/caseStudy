//
//  Configuration.swift
//  LeanScale
//
//  Created by Mayank G on 26/02/21.
//  Copyright © 2021 Mayank G. All rights reserved.
//

import UIKit

struct Config: Decodable {
    let backendUrl: String
    private enum CodingKeys: String, CodingKey {
        case backendUrl = "Backend Url"
    }
}

struct Configuration {
    static func listingUrl() -> String {
        return infoForKey("Backend Url")! + "?page_size=10&page=1"
    }
    
    static func gameSearchUrl(search: String) -> String {
        return infoForKey("Backend Url")! + "?page_size=10&page=1&search=" + "\(search)"
    }
    
    static func gameDescUrl(id: Int) -> String {
        return infoForKey("Backend Url")! + "/\(id)"
    }
  
    static func infoForKey(_ key: String) -> String? {
           return (Bundle.main.infoDictionary?[key] as? String)?
               .replacingOccurrences(of: "\\", with: "")
    }
}

struct UIConfiguration {
    static let viewedColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
    static let activityIndicatorColor = UIColor.gray
    static let searchBarLimit = 3
}
