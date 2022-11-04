//
//  APBarcodeScanner.swift
//  iKhokhaFruits
//
//  Created by Wykee on 02/11/2022.
//  Copyright © 2022 VINT. All rights reserved.
//

import Firebase
import AVFoundation
import MLKitBarcodeScanning
import MLKitVision

protocol APBarcodeScannerDelegate: AnyObject {
    func scannerDidCaptureCode(barCode: String)
}

class APBarcodeScanner: UIView, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var captureSession : AVCaptureSession?
    var previewLayer : AVCaptureVideoPreviewLayer?
    weak var delegate: APBarcodeScannerDelegate?
    weak var scannerView: UIView?
    weak var frameView: UIView?
  
    init(scannerView: UIView, frameLayer: UIView) {
        super.init(frame: CGRect(x: 0, y: 0, width: scannerView.frame.width, height: scannerView.frame.height))
        self.scannerView = scannerView
        self.frameView = frameLayer
        scannerView.addSubview(self)
        scannerView.clipsToBounds = true
    }
    
    func scanBarcode(){
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = .high
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        
        if captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
        }else {
            print("error")
            return
        }
        
        let dataOutput = AVCaptureVideoDataOutput()

        if captureSession!.canAddOutput(dataOutput) {
            captureSession!.addOutput(dataOutput)
            dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        }else {
            print("error")
            return
        }
        
        //CAM - Layer
        previewLayer = AVCaptureVideoPreviewLayer()
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.frame = scannerView?.layer.bounds ?? CGRect.zero//?.frame ?? CGRect.zero
        previewLayer?.videoGravity = .resizeAspectFill
        self.layer.addSublayer(previewLayer!)
        
        if !(captureSession!.isRunning) {
            captureSession!.startRunning()
        }
        self.scannerView?.insertSubview(frameView!, aboveSubview: scannerView!)
    }
    
    func imageOrientation(deviceOrientation: UIDeviceOrientation,cameraPosition: AVCaptureDevice.Position) -> UIImage.Orientation {
      switch deviceOrientation {
      case .portrait:
        return cameraPosition == .front ? .leftMirrored : .right
      case .landscapeLeft:
        return cameraPosition == .front ? .downMirrored : .up
      case .portraitUpsideDown:
        return cameraPosition == .front ? .rightMirrored : .left
      case .landscapeRight:
        return cameraPosition == .front ? .upMirrored : .down
      case .faceDown, .faceUp, .unknown:
        return .up
      }
    }
          
    
    func barcodeReader(buffer: CMSampleBuffer){
        
        let format = BarcodeFormat.code128
        let barcodeOptions = BarcodeScannerOptions(formats: format)
        
        let image = VisionImage(buffer: buffer)
        image.orientation = imageOrientation(
          deviceOrientation: UIDevice.current.orientation,
          cameraPosition: .back)
        
        let barcodeDetector = BarcodeScanner.barcodeScanner(options: barcodeOptions)
        
        barcodeDetector.process(image) { features, error in
          guard error == nil, let features = features, !features.isEmpty else {
            // Error handling
            return
          }
            
          // Recognized barcodes
            for barcode in features {
                self.delegate?.scannerDidCaptureCode(barCode: barcode.displayValue!)
                //self.stopScanning()
            }
        }
    }
    
    func stopScanning(){
        if captureSession?.isRunning ?? false {
            captureSession?.stopRunning()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is needed")
    }

    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = AVCaptureVideoOrientation.portrait
        barcodeReader(buffer: sampleBuffer)
    }
    
    func convert(cmage:CIImage) -> UIImage{
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
}
