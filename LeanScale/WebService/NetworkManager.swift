//
//  WebService.swift
//  LeanScale
//
//  Created by Mayank G on 26/02/21.
//  Copyright © 2021 Mayank G. All rights reserved.
//

import Foundation

enum Response<T> {
    case success(T)
    case failure(Error)
}

class NetworkManager {
    static let sharedInstance = NetworkManager()

    // MARK: - Properties
    private var session: URLSession!
    
    // MARK: - Initializer
    init() {
        session = URLSession(configuration: .ephemeral)
    }
    
    deinit {
        cancelAllTask()
    }
    
    // MARK: - Public Methods
    public func dataTaskFromURL<T: Decodable>(_ url: URL, completion: @escaping ((Response<T>) -> Void)) -> URLSessionDataTask {
        return session.dataTask(with: url, completionHandler: { (data, response, error) in
            if error == nil,
                let data = data {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(response))
                } catch let parsingError {
                    completion(.failure(parsingError))
                }
            } else {
                completion(.failure(error!))
            }
        })
    }
    
    
    private static func getData(url: URL,
                                completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
        
    public static func downloadImage(url: URL,
                                     completion: @escaping (Response<Data>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            NetworkManager.getData(url: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async() {
                    completion(.success(data))
                }
            }
        }
    }
    
    public static func getGameData(sourceURL: URL, completion : @escaping ([Result]?, Error?) -> ()) {
        URLSession.shared.dataTask(with: sourceURL) { (data, urlResponse, error) in
            
            if let error = error {
                completion(nil, error)
            } else {
                guard let data = data else { return }
                do {
                    let json = try JSONDecoder().decode(Games<[Result]>.self, from: data)
                    completion(json.results, nil)
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
    }
    
    public func cancelAllTask() {
        session.invalidateAndCancel()
    }
}
