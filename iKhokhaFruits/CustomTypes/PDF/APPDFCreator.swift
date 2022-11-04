//
//  APPDFCreator.swift
//  iKhokhaFruits
//
//  Created by Wykee on 04/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import Foundation
import AVFoundation
import Firebase
import PDFKit

class APPDFCreator: NSObject {
    let defaultOffset: CGFloat = 14
    let headerTitles: [String]
    let productsItems: [APProductsModel]

    init(tableDataItems: [APProductsModel], tableDataHeaderTitles: [String]) {
        self.productsItems = tableDataItems
        self.headerTitles = tableDataHeaderTitles
    }

    func create(total: String) -> Data {
        
        let format = UIGraphicsPDFRendererFormat()
        let metaData = [
            kCGPDFContextTitle: "Ikhokha",
            kCGPDFContextAuthor: "ikhokha.com LLC"
        ]
        
        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect,
                                             format: format)

        let numberOfElementsPerPage = calculateNumberOfElementsPerPage(with: pageRect)
        let tableDataChunked: [[APProductsModel]] = productsItems.chunkedElements(into: numberOfElementsPerPage)

        let data = renderer.pdfData { context in
            for tableDataChunk in tableDataChunked {
                let cgContext = context.cgContext
                context.beginPage()
                //draw image logo
                
                let paragraphStyle = NSMutableParagraphStyle()
                let textFont = UIFont.systemFont(ofSize: 16.0, weight: .bold)
                paragraphStyle.alignment = .center
                paragraphStyle.lineBreakMode = .byWordWrapping
                let textColor = UIColor(named: "green")
                let attributesforBiggerText = [
                    NSAttributedString.Key.foregroundColor: UIColor(ciColor: .black),
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
                
                let attributes = [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.font: textFont,
                    NSAttributedString.Key.foregroundColor: textColor
                ]
                
                if let image = UIImage(named: "iKhokhalogo") {
                    let imageRect = CGRect(x: 8, y: 5, width: 60, height: 36)
                    let frame = AVMakeRect(aspectRatio: CGSize(width: 60, height: 36), insideRect: imageRect)
                    image.draw(in: frame)
                    
                    let invoice = "Invoice #1033"
                    let invoiceRect = CGRect(x: 100,
                                          y: 5, width: 100, height: 30)
                    invoice.draw(in: invoiceRect, withAttributes: attributesforBiggerText)
                    
                    let date = Date()
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let dateString = "Date:: \(df.string(from: date))"
        
                    let dateRect = CGRect(x: 100, y: 20,
                                          width: 200, height: 30)
                    dateString.draw(in: dateRect, withAttributes: attributesforBiggerText)
                }
                
                drawTableHeaderRect(drawContext: cgContext, pageRect: pageRect)
                drawTableHeaderTitles(titles: headerTitles, drawContext: cgContext, pageRect: pageRect)
                drawTableContentInnerBordersAndText(drawContext: cgContext, pageRect: pageRect, tableDataItems: tableDataChunk)
                
                
                let totalCost = "Total Price: $\(total)"
    
                let totalRect = CGRect(x: 100, y: 800,
                                      width: 280, height: 30)
                totalCost.draw(in: totalRect, withAttributes: attributes)
            }
        }
        return data
    }

    func calculateNumberOfElementsPerPage(with pageRect: CGRect) -> Int {
        let rowHeight = (defaultOffset * 3)
        let number = Int((pageRect.height - rowHeight) / rowHeight)
        return number
    }
}

extension Array {
    func chunkedElements(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension APPDFCreator {
    func drawTableHeaderRect(drawContext: CGContext, pageRect: CGRect) {
        drawContext.saveGState()
        drawContext.setLineWidth(1.0)

//        // Draw header's 1 top horizontal line
//        drawContext.move(to: CGPoint(x: defaultOffset, y: defaultOffset))
//        drawContext.addLine(to: CGPoint(x: pageRect.width - defaultOffset, y: defaultOffset))
//        drawContext.strokePath()

        // Draw header's 1 bottom horizontal line
        drawContext.move(to: CGPoint(x: defaultOffset, y: defaultOffset * 3))
        drawContext.addLine(to: CGPoint(x: pageRect.width - defaultOffset, y: defaultOffset * 3))
        drawContext.strokePath()

//        // Draw header's 3 vertical lines
//        drawContext.setLineWidth(2.0)
//        drawContext.saveGState()
//        let tabWidth = (pageRect.width - defaultOffset * 2) / CGFloat(3)
//        for verticalLineIndex in 0..<4 {
//            let tabX = CGFloat(verticalLineIndex) * tabWidth
//            drawContext.move(to: CGPoint(x: tabX + defaultOffset, y: defaultOffset))
//            drawContext.addLine(to: CGPoint(x: tabX + defaultOffset, y: defaultOffset * 3))
//            drawContext.strokePath()
//        }

        drawContext.restoreGState()
    }

    func drawTableHeaderTitles(titles: [String], drawContext: CGContext, pageRect: CGRect) {
        // prepare title attributes
        let textFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        let textColor = UIColor(named: "faded_green")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        let titleAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor
        ]

        // draw titles
        let tabWidth = (pageRect.width - defaultOffset * 2) / CGFloat(3)
        for titleIndex in 0..<titles.count {
            let attributedTitle = NSAttributedString(string: titles[titleIndex].capitalized, attributes: titleAttributes)
            let tabX = CGFloat(titleIndex) * tabWidth
            let textRect = CGRect(x: tabX + defaultOffset,
                                  y: defaultOffset * 3 / 2,
                                  width: tabWidth,
                                  height: defaultOffset * 2)
            attributedTitle.draw(in: textRect)
        }
    }

    func drawTableContentInnerBordersAndText(drawContext: CGContext, pageRect: CGRect, tableDataItems: [APProductsModel]) {
        drawContext.setLineWidth(0.8)
        drawContext.saveGState()

        let defaultStartY = defaultOffset * 3

        for elementIndex in 0..<tableDataItems.count {
            let yPosition = CGFloat(elementIndex) * defaultStartY + defaultStartY

            // Draw content's elements texts
            let textFont = UIFont.systemFont(ofSize: 10.0, weight: .regular)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byWordWrapping
            let textAttributes = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: textFont
            ]
            
            let tabWidth = (pageRect.width - defaultOffset * 2) / CGFloat(3)
            for titleIndex in 0..<3 {
                var attributedText = NSAttributedString(string: "", attributes: textAttributes)
                switch titleIndex {
                case 0: attributedText = NSAttributedString(string: tableDataItems[elementIndex].description!, attributes: textAttributes)
                case 1: attributedText = NSAttributedString(string: String(format: "%.2f", tableDataItems[elementIndex].count ?? 1.0), attributes: textAttributes)
                case 2: attributedText = NSAttributedString(string: String(format: "%.2f", tableDataItems[elementIndex].price!), attributes: textAttributes)
                default:
                    break
                }
                let tabX = CGFloat(titleIndex) * tabWidth
                let textRect = CGRect(x: tabX + defaultOffset,
                                      y: yPosition + defaultOffset,
                                      width: tabWidth,
                                      height: defaultOffset * 3)
                attributedText.draw(in: textRect)
            }

            // Draw content's 3 vertical lines
            for verticalLineIndex in 0..<4 {
                let tabX = CGFloat(verticalLineIndex) * tabWidth
                drawContext.move(to: CGPoint(x: tabX + defaultOffset, y: yPosition))
                drawContext.addLine(to: CGPoint(x: tabX + defaultOffset, y: yPosition + defaultStartY))
                drawContext.strokePath()
            }

            // Draw content's element bottom horizontal line
            drawContext.move(to: CGPoint(x: defaultOffset, y: yPosition + defaultStartY))
            drawContext.addLine(to: CGPoint(x: pageRect.width - defaultOffset, y: yPosition + defaultStartY))
            drawContext.strokePath()
        }
        drawContext.restoreGState()
    }
}
