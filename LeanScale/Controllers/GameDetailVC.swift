//
//  GameDetailVC.swift
//  LeanScale
//
//  Created by Mayank G on 26/02/21.
//  Copyright © 2021 Mayank G. All rights reserved.
//

import UIKit
import CoreData

enum BarButtonType : String {
    case Favourite = "Favourite"
    case Favourited = "Favourited"
}

class GameDetailVC: UIViewController {

    public var gameId: Int!
    @IBOutlet weak var imageViewGame: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var lblTitleGame: UILabel!
    private var gameDescViewModel : GameDescViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        CoreData.saveViewedGame(id: gameId)
        gameDescViewModel =  GameDescViewModel()
        gameDescViewModel.getData(gameId: gameId)
        gameDescViewModel.bindGamesViewModelToController = {
            DispatchQueue.main.async {
                if let backgroundImage = self.gameDescViewModel.gameDesc.backgroundImage {
                    self.imageViewGame.loadImage(urlSting: backgroundImage)
                }
                self.lblTitleGame.text = self.gameDescViewModel.gameDesc.name
                self.tableView.reloadData()
                self.initGameFavData();
            }
        }
    }
    
    private func initGameFavData() {
        var rightBtnTitle = BarButtonType.Favourite.rawValue
        let favGames = CoreData.fetchFavGaame()
        if favGames.count > 0 {
            let gamesID = favGames.map { $0.id}
            if gamesID.contains(Int32(gameId)) {
                rightBtnTitle = BarButtonType.Favourited.rawValue
            }
        }
        let rightBtn = UIBarButtonItem(title: rightBtnTitle, style: .plain, target: self, action: #selector(btnFavourite))
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    @objc func btnFavourite(_ sender: UIBarButtonItem) {
        if sender.title == BarButtonType.Favourite.rawValue {
            CoreData.saveFavouriteGame(game: self.gameDescViewModel.gameDesc)
            sender.title = BarButtonType.Favourited.rawValue
        } else {
            let favGames = CoreData.fetchFavGaame()
            if favGames.count > 0 {
                if let game = favGames.first(where: {$0.id == gameId}) {
                    CoreData.removeFavGame(game: game)
                    sender.title = BarButtonType.Favourite.rawValue
                }
            }
        }
    }
    
    func moreTapped(cell: GameDetailTableViewCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}


extension GameDetailVC: UITableViewDataSource, UITableViewDelegate, GameDescriptionDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
          let cell = tableView.dequeueReusableCell(withIdentifier: "GameDetailTableViewCell", for: indexPath) as! GameDetailTableViewCell
            if let gameDesc = self.gameDescViewModel.gameDesc {
                cell.myInit(description: gameDesc.description!)
            }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GameSocialCell", for: indexPath) as! GameSocialCell
            cell.lblSocial.text = indexPath.row == 1 ? "Visit reddit" : "Visit website"
            cell.selectionStyle = .default
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { return }
        
        if let strSocial = getSocialUrl(indexPath: indexPath) {
            if let link = URL(string: strSocial) {
              UIApplication.shared.open(link)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getSocialUrl(indexPath: IndexPath) -> String? {
        return indexPath.row == 1 ? self.gameDescViewModel.gameDesc.redditURL : self.gameDescViewModel.gameDesc.website
    }
}
