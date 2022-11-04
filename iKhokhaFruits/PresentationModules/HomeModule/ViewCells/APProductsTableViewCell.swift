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
    @IBOutlet weak var fruitPrice: UILabel!
    @IBOutlet weak var fruitCount: UILabel!
    @IBOutlet weak var minusProductBtn: APBindingButton!{
        didSet{
            self.minusProductBtn.bind {
                print("Mins")
            }
        }
    }
    @IBOutlet weak var plusProductBtn: APBindingButton!{
        didSet{
            self.plusProductBtn.bind {
                print("Plus......\\")
            }
        }
    }
    
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bottomSpace: CGFloat = 12
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: bottomSpace, right: 0))
        self.contentView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
