//
//  GameDetailTableViewCell.swift
//  LeanScale
//
//  Created by Mayank G on 28/02/21.
//  Copyright © 2021 Mayank G. All rights reserved.
//

import Foundation
import UIKit

class GameDetailTableViewCell: UITableViewCell {
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var btnMore: UIButton!
    var isExpanded: Bool = false
    var delegate: GameDescriptionDelegate?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func myInit(description: String) {
        isExpanded = false
        lblDescription.attributedText = description.htmlToAttributedString
        lblDescription.numberOfLines = 4
    }
    
    @IBAction func btnMoreTapped(_ sender: Any) {
        if sender is UIButton {
            isExpanded = !isExpanded
            lblDescription.numberOfLines = isExpanded ? 0 : 4
            btnMore.setTitle(isExpanded ? "Read less..." : "Read more...", for: .normal)
            delegate?.moreTapped(cell: self)
        }
    }
}

protocol GameDescriptionDelegate {
    func moreTapped(cell: GameDetailTableViewCell)
}
