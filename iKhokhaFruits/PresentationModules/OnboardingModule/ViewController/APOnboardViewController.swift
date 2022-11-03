//
//  APOnboardViewController.swift
//  iKhokhaFruits
//
//  Created by Wykee on 03/11/2022.
//  Copyright © 2022 iKhokha. All rights reserved.
//

import UIKit

class APOnboardViewController: UIViewController {

    @IBOutlet var image: UIImageView!
    @IBOutlet var footTitle: UILabel!
    @IBOutlet var footNote: UILabel!
    
    @IBOutlet var vONE: UIView!
    @IBOutlet var vTWO: UIView!
    @IBOutlet var vTHREE: UIView!
    
    @IBOutlet weak var getStartedBtn: UIButton!
    
    var pos = 0
    
    let titles: [String] = [OnboardingTitles.scan, OnboardingTitles.cart, OnboardingTitles.receipt]
    
    let footNotes: [String] = [OnboardingSubTitles.scan, OnboardingSubTitles.cart, OnboardingSubTitles.receipt]
    
    let images = [OnboardingImages.scan, OnboardingImages.cart, OnboardingImages.receipt]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.image.image = images[0]
        self.footTitle.text = titles[0]
        self.footNote.text = footNotes[0]
        
        let isOnboardingShown = UserDefaults.standard.bool(forKey: "isOnboarding")
        if isOnboardingShown{
            navigateHome()
        }
    }
    
    @IBAction func getStarted(_ sender: Any) {
        navigateHome()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.animateViews()
        self.initSwipe()
        self.getStartedBtn.isEnabled = false
    }
    
    func navigateHome(){
        UserDefaults.standard.set(true, forKey: "isOnboarding")
        let hardWallVC = Accessors.AppDelegate.delegate.appDiContainer.makeHardWallDIContainer().makeHardWallViewController()
        hardWallVC.modalTransitionStyle = .coverVertical
        hardWallVC.modalPresentationStyle = .fullScreen
        self.present(hardWallVC, animated: true)
    }
    
    func initSwipe(){
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onBoardingSwipeMade(_:)))
        leftRecognizer.direction = .left
        
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onBoardingSwipeMade(_:)))
        rightRecognizer.direction = .right
        self.view.addGestureRecognizer(leftRecognizer)
        self.view.addGestureRecognizer(rightRecognizer)
    }
    
    @IBAction func onBoardingSwipeMade(_ sender: UISwipeGestureRecognizer) {
       if sender.direction == .left {
           self.pos = self.pos + 1
           if pos > 2 {
               pos = 2
           }else{
               self.setOnBoardingValues(pos: pos)
           }
           
           if pos == 2{
               self.getStartedBtn.isEnabled = true
           }
       }
        
       if sender.direction == .right {
           self.pos = self.pos - 1
           if pos < 0 {
               pos = 0
           }else{
               self.setOnBoardingValues(pos: pos)
           }
       }
    }
    
    func setOnBoardingValues(pos: Int){
        self.image.image = images[pos]
        self.footTitle.text = titles[pos]
        self.footNote.text = footNotes[pos]
        self.observerIndicator()
        self.animateViews()
    }
    
    func observerIndicator(){
        switch self.pos{
        case 0:
            self.vTWO.backgroundColor = UIColor(named: "gray")
            self.vTHREE.backgroundColor = UIColor(named: "gray")
            self.vONE.backgroundColor = UIColor(named: "green")
            
        case 1:
            self.vONE.backgroundColor = UIColor(named: "gray")
            self.vTHREE.backgroundColor = UIColor(named: "gray")
            self.vTWO.backgroundColor = UIColor(named: "green")
        case 2:
            self.vONE.backgroundColor = UIColor(named: "gray")
            self.vTWO.backgroundColor = UIColor(named: "gray")
            self.vTHREE.backgroundColor = UIColor(named: "green")
        default:
            break
        }
    }
    
    func animateViews(){
        UIView.animate(withDuration: 0.0) {
            self.image.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
         }
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
            self.footTitle.center.y += 30.0
            self.footTitle.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
            self.image.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.image.alpha = 1.0
        }, completion: nil)
    }

}
