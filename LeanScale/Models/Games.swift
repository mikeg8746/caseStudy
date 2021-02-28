//
//  Game.swift
//  LeanScale
//
//  Created by Mayank G on 26/02/21.
//  Copyright © 2021 Mayank G. All rights reserved.
//

import Foundation
import CoreData

struct Games<T>: Decodable where T: Decodable {
    let count: UInt?
    let next: String?
    let previous: String?
    let results: T?
    enum CodingKeys: String, CodingKey {
        case count, next, previous, results
    }
}

struct Result: Decodable {
    let id: Int?
    let name: String?
    let backgroundImage: String?
    let metacritic: Int?
    let genres: [Genre]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case backgroundImage = "background_image"
        case metacritic
        case genres
    }
}

struct Genre: Decodable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

struct GameData: Decodable {
    let id: Int?
    let name, description: String?
    let backgroundImage: String?
    let website: String?
    let redditURL: String?
    let metacritic: Int?
    let genres: [Genre]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case description
        case backgroundImage = "background_image"
        case website, redditURL
        case metacritic
        case genres
    }
}
