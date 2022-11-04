//
//  APProductViewController.swift
//  iKhokhaFruits
//
//  Created by Wykee on 03/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import UIKit

class APCartViewController: BaseViewController {
    
    
    @IBOutlet weak var backBtn: APBindingButton!{
        didSet{
            self.backBtn.bind {
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBOutlet weak var printRecipt: APBindingButton!{
        didSet{
            self.printRecipt.bind {
                ///print receipt
                self.viewModel.createPDF()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.register(APProductsTableViewCell.self)
            tableView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var totalPrice: UILabel!
    
    var products: [APProductsModel] = []
    var barCodes: [String] = []
    
    var viewModel: APCartViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.viewModel.productsData.value = self.products
        self.tableView.reloadData()
    }
    
    final class func create(with viewModel: APCartViewModel) -> APCartViewController {
        let view = APCartViewController(nibName: "APCartViewController", bundle: nil)
        view.viewModel = viewModel
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bindViewModel()
        self.viewModel.getTotal()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
                        self?.sharePDF()
                    }
                    self?.tableView.reloadData()
                    break
                case .total:
                    if let total = self?.viewModel.total.value{
                        self?.totalPrice.text = "$\(total)"
                    }
                    break
                case .error:
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    func sharePDF(){
        if let path = self.viewModel.pdfUrl.value{
            let fileManager = FileManager.default

            if fileManager.fileExists(atPath: path!.path) {
                let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [path], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }else {
                print("document was not found")
            }
        }
    }
    

}


extension APCartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension APCartViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.products.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView[APProductsTableViewCell.self, indexPath]
        let products = self.products[indexPath.row]
        
        let index = indexPath.row
        cell.index = index
        cell.plusProductBtn.tag = index
        cell.minusProductBtn.tag = index
        
        if let price = products.price{
            cell.fruitPrice.text = "$\(price)"
        }
        
        cell.fruitTitle.text = products.description
        cell.fruitCount.text = "\(products.count ?? 1)"
        
        let endPoint = APAPIEndPoints.Requests.getProductsImagesEndPoint()
        if let imageUrl = products.image{
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
