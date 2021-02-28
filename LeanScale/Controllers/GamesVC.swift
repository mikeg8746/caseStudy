//
//  FirstViewController.swift
//  LeanScale
//
//  Created by Mayank G on 26/02/21.
//  Copyright © 2021 Mayank G. All rights reserved.
//

import UIKit

class GamesVC: UIViewController {

    @IBOutlet weak var gamesTableView: UITableView!
    @IBOutlet var lblError: UILabel!
    @IBOutlet var loaderView: LoadingView!
    @IBOutlet var searchBar: UISearchBar!
    
    internal var arrGames: [Result]?
    internal var gamesViewModel: GamesViewModel<[Result], Result>!
    internal var nextUrl:String?
    internal let cellIdentifier: String = "GameTableViewCell"
    internal let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gamesTableView.tableFooterView = UIView()
        gamesViewModel = GamesViewModel(transform: { result -> [Result] in
            return result
        })
        loadGamesData()
    }
    
    internal func loadGamesData() {
        let loadingInfo = gamesViewModel.loadMoreData(page: nextUrl) { [weak self] (data, error, nextPage) in
            DispatchQueue.main.async {
                if let data = data {
                    self?.updateErrorLbl(errorMsg: error?.localizedDescription, data: data)
                    self?.arrGames = data
                    self?.gamesTableView.reloadData()
                    if let nextPage = nextPage {
                        self?.nextUrl = nextPage
                    }
                    self?.loaderView.hide()
                } else {
                    if self?.nextUrl != nil {
                        self?.loaderView.showMessage("Error loading data.", animateLoader: false, autoHide: 5.0)
                    } else {
                        self?.updateErrorLbl(errorMsg: error?.localizedDescription, data: data)
                    }
                }
            }
        }
        
        if loadingInfo.isLoading {
            if nextUrl != nil {
                loaderView.showMessage("Loading...", animateLoader: true)
            }
            
        } else {
            loaderView.hide()
        }
    }
    
    func updateErrorLbl(errorMsg: String?, data: [Result]?) {
        if errorMsg != nil || data?.count == 0 {
            self.gamesTableView.isHidden = true
            self.lblError.isHidden = false
            if data?.count == 0 {
                self.lblError.text = searchBar.text!.count >= UIConfiguration.searchBarLimit ? "No game has been searched" : "No game found"
            } else {
                self.lblError.text = errorMsg!
            }
        } else {
            self.gamesTableView.isHidden = false
            self.lblError.isHidden = true
        }
    }
    
    internal func pushToGameDetail(with gameId: Int) {
        guard let gameDetail = Navigation.getViewController(type: GameDetailVC.self,
                                                          identifer: "GameDetailVC") else { return }
        gameDetail.gameId = gameId
        gameDetail.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(gameDetail, animated: true)
    }
}

extension GamesVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= UIConfiguration.searchBarLimit {
            self.arrGames = []
            self.gamesViewModel.datasource = []
            self.gamesTableView.reloadData()
            self.nextUrl = Configuration.gameSearchUrl(search: searchText)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.loadGamesData()
            }
        }
        if searchText.isEmpty {
            self.nextUrl = nil
            self.arrGames = []
            self.gamesViewModel.datasource = []
            loadGamesData()
        }
    }
}
