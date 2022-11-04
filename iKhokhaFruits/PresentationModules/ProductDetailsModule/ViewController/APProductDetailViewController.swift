//
//  APProductDetailViewController.swift
//  iKhokhaFruits
//
//  Created by Wykee on 04/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import UIKit

class APProductDetailViewController: UIViewController {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    var image: String?
    var namee: String?
    var price: Double?
    
    @IBOutlet weak var backBtn: APBindingButton!{
        didSet{
            self.backBtn.bind {
                self.dismiss(animated: true)
            }
        }
    }
    
    
    @IBOutlet weak var cartBtn: APBindingButton!{
        didSet{
            self.cartBtn.bind {
                self.dismiss(animated: true)
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    final class func create() -> APProductDetailViewController {
        let view = APProductDetailViewController(nibName: "APProductDetailViewController", bundle: nil)
        return view
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.productName.text = self.namee
        self.productImage.setImageUrl(url: URL(string: self.image!)!)
        self.productPrice.text = "$\(self.price!)"
    }

}
