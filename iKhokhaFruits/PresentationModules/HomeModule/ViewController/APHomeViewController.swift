//
//  APHomeViewController.swift
//  iKhokhaFruits
//
//  Created by Wykee on 03/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import UIKit
import AVFoundation

class APHomeViewController: BaseViewController, APBarcodeScannerDelegate{
    
    @IBOutlet weak var profile: APBindingButton!
    
    @IBOutlet weak var cartBtn: APBindingButton!
    
    @IBOutlet weak var scannerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(APProductsTableViewCell.self)
            tableView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var checkOutBtn: APBindingButton!
    
    @IBOutlet weak var frameView: UIView!
    
    var viewModel: APHomeViewModel!
    var barcodeScanner: APBarcodeScanner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        barcodeScanner = APBarcodeScanner.init(scannerView: scannerView, frameLayer: frameView)
        barcodeScanner?.delegate = self
        barcodeScanner?.scanBarcode()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.viewModel.
        self.bindViewModel()
        self.tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    final class func create(with viewModel: APHomeViewModel) -> APHomeViewController {
        let view = APHomeViewController(nibName: "APHomeViewController", bundle: nil)
        view.viewModel = viewModel
        return view
    }
   
    var beepEffect: AVAudioPlayer?
    
    func scannerDidCaptureCode(barCode: String) {
        let codes = viewModel.scannedBarcodes.value
        if let barcodesArray = codes, barcodesArray.contains(barCode){
            print("The code is already registered,.....\(String(describing: codes))")
            ///show alert to add that item twice
        }else{
            self.viewModel.scannedBarcodes.value?.append(barCode)
            print("Code is not registeres......\(String(describing: codes))")
            self.beep()
            self.viewModel.getProductDetails(barCode: barCode)
        }

    }
    
    func beep(){
        let path = Bundle.main.path(forResource: "beep.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            beepEffect = try AVAudioPlayer(contentsOf: url)
            beepEffect?.play()
        } catch {
            print("No such fucking file -):")
        }
    }
    
    func bindViewModel(){
        self.viewModel.route.bind = { [weak self] route in
            DispatchQueue.main.async {
                switch route{
                case .activity(let isloading):
                    if isloading{
                        self?.showHUD()
                    }else{
                        self?.hideHUD()
                    }
                    self?.updateCart()
                    break
                case .error:
                    break
                default:
                    break
                }
            }
        }
        self.viewModel.productsData.bind = { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    func updateCart(){
        let count = self.viewModel.productsData.value?.count
        self.cartBtn.badgeValue = "\(count ?? 0)"
    }
    
}

extension APHomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.viewModel.productsData.value?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView[APProductsTableViewCell.self, indexPath]
        let products = self.viewModel.productsData.value?[indexPath.row]
        
        cell.fruitPrice.text = "$\(String(describing: products?.price!))"
        cell.fruitTitle.text = products?.description
        cell.fruitCount.text = "\(products?.count ?? 1)"
        
        let endPoint = APAPIEndPoints.Requests.getProductsImagesEndPoint()
        let imageUrl = URL(string: "\(endPoint.appendingPathExtension("\(String(describing: products?.image))?alt=media"))")!
        
        print(".......UEL..\(imageUrl)")
        
        cell.fruitImage.setImageUrl(url: imageUrl)
        
        return cell
    }
    


}
