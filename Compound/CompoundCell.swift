//
//  CompoundCell.swift
//  Compound
//
//  Created by Daniel Maness on 7/31/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import UIKit

class CompoundCell: UITableViewCell {
    var rank: Int!
    
    @IBOutlet weak var trophyImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var waitingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}