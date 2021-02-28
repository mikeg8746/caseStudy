//
//  GamesViewModel.swift
//  LeanScale
//
//  Created by Mayank G on 26/02/21.
//  Copyright © 2021 Mayank G. All rights reserved.
//

import Foundation

class GamesViewModel<T, E> where T:Decodable {
    typealias GamesDataResult = ((_ data: [E]?, _ error: Error?, _ nextPage: String?) -> Void)
    typealias GameDescResult = ((_ data: E?, _ error: Error?) -> Void)
    private lazy var networkManager = NetworkManager()
    public lazy var datasource: [E] = []
    private var dataTask: URLSessionDataTask?
    private let transform: ((T) -> [E])
    
    init(transform block: @escaping ((T) -> [E])) {
        self.transform = block
    }
    
    // MARK: - De-Initializer
    deinit {
        dataTask?.cancel()
    }
    
    @discardableResult
    public func loadMoreData(page next: String?, handler: @escaping GamesDataResult) -> (isLoading: Bool, nextPage: String?) {
        guard dataTask?.state != .running else { return (true, next) }
        loadData(page: next, completionHandler: handler)
        return (true, next)
    }
    
    private func loadData(page next: String?, completionHandler: @escaping GamesDataResult) {
        let url = (next != nil) ? next! : Configuration.listingUrl()
        let sourcesURL = URL(string: url)!
        
        dataTask = networkManager.dataTaskFromURL(sourcesURL,
                                                  completion: { [weak self] (result: Response<Games<T>>) in
            switch result {
            case .success(let response):
                guard let responseData = response.results else { return completionHandler([], nil, nil) }
                guard let data = self?.transform(responseData) else { return completionHandler([], nil, nil) }
                self?.datasource.append(contentsOf: data)
                completionHandler(self?.datasource, nil, response.next)
            case .failure(let error):
                completionHandler(nil, error, nil)
            }
        })
        dataTask?.resume()
    }
}
