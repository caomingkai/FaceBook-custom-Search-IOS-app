//
//  GroupsCellTableViewCell.swift
//  slideout
//
//  Created by Kevin on 23/04/2017.
//  Copyright © 2017 Kevin Chaos. All rights reserved.
//

import UIKit

class ResultAndFavorCellTableViewCell: UITableViewCell {

    @IBOutlet weak var favorImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImg: UIImageView!
    override func awakeFromNib() {

        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
