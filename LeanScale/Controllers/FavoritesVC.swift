//
//  SecondViewController.swift
//  LeanScale
//
//  Created by Mayank G on 26/02/21.
//  Copyright © 2021 Mayank G. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {
    @IBOutlet var favTableView: UITableView!
    @IBOutlet var lblError: UILabel!
    @IBOutlet var lblTitle: UILabel!
    var favGames = [FavGame]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    func updateData() {
        favGames = CoreData.fetchFavGaame()
        favTableView.reloadData()
        if favGames.count == 0 {
            lblError.isHidden = false
            self.favTableView.isHidden = true
            self.lblTitle.text = "Favourites"
        } else {
            self.lblTitle.text = "Favourites (\(favGames.count))"
            lblError.isHidden = true
            favTableView.isHidden = false
        }
    }
}

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favGames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavGameTableViewCell", for: indexPath) as! GameTableViewCell
        
        let game = favGames[indexPath.row]
        cell.lblTitle.text = game.name
        cell.lblMetacritic.text = String(game.metacritic)
        if let backgroundImage = game.backgroundImage {
            cell.imageViewGame.loadImage(urlSting: backgroundImage)
        }
        let genres = game.favgenre as! Set<FavGenre>
        cell.lblGenre.text = genres.map{ $0.name! }.joined(separator:", ")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let gameDetailVC = Navigation.getViewController(type: GameDetailVC.self,
                                                          identifer: "GameDetailVC") else { return }
        gameDetailVC.gameId = Int(favGames[indexPath.row].id)
        gameDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(gameDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if favGames.count > 0 {
               askUserForConfirmation(indexPath: indexPath)
            }
        }
    }
    
    func askUserForConfirmation(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Alert!", message: "Are you sure you want to delete?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let game = self.favGames.first(where: {$0.id == Int(self.favGames[indexPath.row].id)}) {
                CoreData.removeFavGame(game: game)
                self.updateData()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
