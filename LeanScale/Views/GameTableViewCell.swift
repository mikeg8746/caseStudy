//
//  GameTableViewCell.swift
//  LeanScale
//
//  Created by Mayank G on 26/02/21.
//  Copyright © 2021 Mayank G. All rights reserved.
//

import Foundation
import UIKit

class GameTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewGame: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMetacritic: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
