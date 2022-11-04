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
    
    @IBOutlet weak var cartBtn: APBindingButton!{
        didSet{
            self.cartBtn.bind {
                let cartVC = Accessors.AppDelegate.delegate.appDiContainer.makeCartDIContainer().makeCartViewController()
                cartVC.modalTransitionStyle = .coverVertical
                cartVC.modalPresentationStyle = .fullScreen
                cartVC.products = self.viewModel.productsData.value ?? []
                cartVC.barCodes = self.viewModel.scannedBarcodes.value ?? []
                self.present(cartVC, animated: true)
            }
        }
    }
    
    @IBOutlet weak var scannerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(APProductsTableViewCell.self)
            tableView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var checkOutBtn: APBindingButton!{
        didSet{
            self.checkOutBtn.bind {
                let cartVC = Accessors.AppDelegate.delegate.appDiContainer.makeCartDIContainer().makeCartViewController()
                cartVC.modalTransitionStyle = .coverVertical
                cartVC.modalPresentationStyle = .fullScreen
                cartVC.products = self.viewModel.productsData.value ?? []
                cartVC.barCodes = self.viewModel.scannedBarcodes.value ?? []
                self.present(cartVC, animated: true)
            }
        }
    }
    
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
    
    func scannerDidCaptureCode(barCode: String) {
        let codes = viewModel.scannedBarcodes.value
        if let barcodesArray = codes, barcodesArray.contains(barCode){
            print("The code is already registered ADD Count For.....\(String(describing: codes))")
            ///show alert to add that item twice
            
        }else{
            self.viewModel.scannedBarcodes.value?.append(barCode)
            self.beep()
            self.viewModel.getProductDetails(barCode: barCode)
        }

    }
    
    var beepEffect: AVAudioPlayer?
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
        self.tableView.reloadData()
    }
    
}

extension APHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension APHomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.viewModel.productsData.value?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView[APProductsTableViewCell.self, indexPath]
        let products = self.viewModel.productsData.value?[indexPath.row]
        
        let index = indexPath.row
        cell.index = index
        cell.plusProductBtn.tag = index
        cell.minusProductBtn.tag = index
        
        if let price = products?.price{
            cell.fruitPrice.text = "$\(price)"
        }
        
        cell.fruitTitle.text = products?.description
        cell.fruitCount.text = "\(products?.count ?? 1)"
        
        let endPoint = APAPIEndPoints.Requests.getProductsImagesEndPoint()
        if let imageUrl = products?.image{
            let url = endPoint.absoluteString.appending("\(imageUrl)?alt=media")
            cell.fruitImage.setImageUrl(url: URL(string: url)!)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let product = self.viewModel.productsData.value?[index]
        let pDVC = Accessors.AppDelegate.delegate.appDiContainer.makePDetailsDIContainer().makePDetailViewController()
        pDVC.price = product?.price
        pDVC.namee = product?.description
        if let imageUrl = product?.image{
            let endPoint = APAPIEndPoints.Requests.getProductsImagesEndPoint()
            let url = endPoint.absoluteString.appending("\(imageUrl)?alt=media")
            pDVC.image = url
        }
        
        pDVC.modalTransitionStyle = .coverVertical
        pDVC.modalPresentationStyle = .fullScreen
        self.present(pDVC, animated: true)
    }
}
