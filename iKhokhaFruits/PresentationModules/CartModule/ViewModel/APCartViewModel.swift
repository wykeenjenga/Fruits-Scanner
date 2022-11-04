//
//  APCartViewModel.swift
//  iKhokhaFruits
//
//  Created by Wykee on 03/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import AVFoundation
import Firebase
import PDFKit
import Kingfisher

enum APCartViewModelRoute {
    case initial
    case error
    case activity(loading: Bool)
    case total
}

protocol APCartViewModelInput {
    func createPDF()
    func getTotal()
}

protocol APCartViewModelOutput {
    var productsData: Dynamic<[APProductsModel]> { get set }
    var route: Dynamic<APCartViewModelRoute> { get set }
    var pdfUrl: Dynamic<URL?> { get set }
    var total: Dynamic<Double> {get set}
    var font: Dynamic<UIFont> {get set}
    var textColor: Dynamic<UIColor>{get set}
}

protocol APCartViewModel: APCartViewModelInput, APCartViewModelOutput {
    
}

final class DefaultAPCartViewModel: APCartViewModel {
    var productsData: Dynamic<[APProductsModel]> = Dynamic([APProductsModel]())
    var route: Dynamic<APCartViewModelRoute> = Dynamic(.initial)
    var pdfUrl: Dynamic<URL?> = Dynamic(URL(string: ""))
    var total: Dynamic<Double> = Dynamic(0.0)
    var font: Dynamic<UIFont> = Dynamic(UIFont())
    var textColor: Dynamic<UIColor> = Dynamic(UIColor(named: "green")!)
    init() {
        
    }
}

extension APCartViewModel{
    
    func createPDF() {
        self.route.value = .activity(loading: true)
        var tableDataItems = self.productsData.value
        
        let tableDataHeaderTitles =  ["Item", "Quantity", "Price"]
        let pdfCreator = APPDFCreator(tableDataItems: tableDataItems!, tableDataHeaderTitles: tableDataHeaderTitles)
        
        if let total = self.total.value{
            let data = pdfCreator.create(total: "\(total)")
            let url = getDocumentsDirectory()
            
            let pdfDocument = PDFDocument(data: data)
            pdfDocument?.write(to: url)
            self.pdfUrl.value = url
            self.route.value = .activity(loading: false)
        }
    }

    
    func getTotal(){
        let products = self.productsData.value
        if let products = products{
            for product in products {
                let price = product.price!
                self.total.value! += price
                self.route.value = .total
            }
        }
    }
    
    //get dir url
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let time = Date().timeIntervalSince1970
        let timeInString = "\(time)"
        let timeWithoutDot = timeInString.components(separatedBy: ".")[0]
        return documentsDirectory.appendingPathComponent("\(timeWithoutDot).pdf")
    }
}





