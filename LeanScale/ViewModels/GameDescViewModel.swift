//
//  GameDescViewModel.swift
//  LeanScale
//
//  Created by Mayank G on 27/02/21.
//  Copyright © 2021 Mayank G. All rights reserved.
//

import Foundation

class GameDescViewModel : NSObject {
    private(set) var gameDesc : GameData! {
        didSet {
            self.bindGamesViewModelToController()
        }
    }
    var bindGamesViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
    }
    
    public func getData(gameId: Int) {
        loadGameDesc(game: gameId) { (data, error) in
            if let data = data {
                self.gameDesc = data
            }
        }
    }
    
    public func loadGameDesc(game id: Int, completionHandler: @escaping ((_ data: GameData?, _ error: Error?) -> Void)) {
        let sourcesURL = URL(string: Configuration.gameDescUrl(id: id))!
        let dataTask: URLSessionDataTask? = NetworkManager().dataTaskFromURL(sourcesURL,
                                                  completion: { (result: Response<GameData?>) in
            switch result {
             case .success(let response):
             guard let data = response else { return completionHandler(nil, nil) }
                completionHandler(data, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        })
        dataTask?.resume()
    }
}
