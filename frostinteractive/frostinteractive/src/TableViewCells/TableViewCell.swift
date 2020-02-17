//
//  TableViewCell.swift
//  frostinteractive
//
//  Created by DWC-LAP-539 on 05/02/20.
//  Copyright © 2020 DWC-LAP-539. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var tagsImage: UIImageView!
    
    @IBOutlet weak var urlToImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet var imageHeightConstant: NSLayoutConstraint!
    @IBOutlet var imageWidthConstant: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        descriptionLabel.sizeToFit()
//        descriptionLabel.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
