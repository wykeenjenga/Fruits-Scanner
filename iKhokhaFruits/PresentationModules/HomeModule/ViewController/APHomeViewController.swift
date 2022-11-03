//
//  APHomeViewController.swift
//  iKhokhaFruits
//
//  Created by Wykee on 03/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import UIKit

class APHomeViewController: UIViewController {
    
    @IBOutlet weak var profile: APBindingButton!
    
    @IBOutlet weak var cartBtn: APBindingButton!
    
    @IBOutlet weak var scannerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var checkOutBtn: APBindingButton!
    
    var viewModel: APHomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.viewModel.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    final class func create(with viewModel: APHomeViewModel) -> APHomeViewController {
        let view = APHomeViewController(nibName: "APHomeViewController", bundle: nil)
        view.viewModel = viewModel
        return view
    }
    
    func bindViewModel(){
        
    }
}

//extension APHomeViewController: UITableViewDataSource, UITableViewDelegate{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//}
