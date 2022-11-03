//
//  APProductsTableViewCell.swift
//  iKhokhaFruits
//
//  Created by Wykee on 03/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import UIKit

class APProductsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fruitImage: UIImageView!
    @IBOutlet weak var fruitTitle: UILabel!
    @IBOutlet weak var fruitDescription: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
