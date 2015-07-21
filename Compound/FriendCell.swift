//
//  FriendCell.swift
//  Compound
//
//  Created by Daniel Maness on 7/21/15.
//  Copyright (c) 2015 Devious Logic. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}