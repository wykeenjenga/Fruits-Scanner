//
//  APHomeViewController.swift
//  iKhokhaFruits
//
//  Created by Wykee on 03/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import UIKit
import AVFoundation

class APHomeViewController: UIViewController, APBarcodeScannerDelegate{
    
    @IBOutlet weak var profile: APBindingButton!
    
    @IBOutlet weak var cartBtn: APBindingButton!
    
    @IBOutlet weak var scannerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var checkOutBtn: APBindingButton!
    
    @IBOutlet weak var frameView: UIView!
    
    var viewModel: APHomeViewModel!
    var barcodeScanner: APBarcodeScanner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        
        barcodeScanner = APBarcodeScanner.init(scannerView: scannerView, frameLayer: frameView)
        barcodeScanner?.delegate = self
        barcodeScanner?.scanBarcode()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.viewModel.
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
    var lastScannedCode = ""
    func scannerDidCaptureCode(barCode: String) {
        if lastScannedCode == barCode {
            print("This is fucking the same code \(lastScannedCode)")
        }else{
            let path = Bundle.main.path(forResource: "beep.mp3", ofType:nil)!
            let url = URL(fileURLWithPath: path)

            do {
                beepEffect = try AVAudioPlayer(contentsOf: url)
                beepEffect?.play()
            } catch {
                print("No such fucking file ):")
            }
            lastScannedCode = barCode
        }
        //self.barcodeScanner.stopScanning()
    }
    
    func bindViewModel(){
        
    }
    
}

//extension APHomeViewController: UITableViewDataSource, UITableViewDelegate{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
//}
