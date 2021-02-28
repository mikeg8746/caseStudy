//
//  GamesTableViewCell.swift
//  LeanScale
//
//  Created by Mayank G on 26/02/21.
//  Copyright © 2021 Mayank G. All rights reserved.
//

import Foundation
import UIKit

extension GamesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGames?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GameTableViewCell
        
        let game = arrGames![indexPath.row]
        cell.lblTitle.text = game.name
        if let metacritic = game.metacritic {
           cell.lblMetacritic.text  = String(metacritic)
        }
        let genres = game.genres!.map{ $0.name }
        cell.lblGenre.text = genres.joined(separator:", ")

        if let backgroundImage = game.backgroundImage {
            cell.imageViewGame.loadImage(urlSting: backgroundImage)
        }
        
        let gamesViewed = CoreData.fetchViewedGames()
        cell.backgroundColor = gamesViewed.contains(game.id!) ? UIConfiguration.viewedColor : UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let gameDetail = arrGames?[indexPath.row] else { return }
        if let cell = tableView.cellForRow(at: indexPath) as? GameTableViewCell {
             cell.backgroundColor = UIConfiguration.viewedColor
        }
        tableView.deselectRow(at: indexPath, animated: true)
        pushToGameDetail(with: gameDetail.id!)
    }
}

extension GamesVC:UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.height
        if bottomEdge >= scrollView.contentSize.height {    //We reached bottom
            loadGamesData()
        }
    }
}
